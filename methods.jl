function plot_result(solver, N)
    angles, d_angles = solver(N)

    x = sin.(angles)
    y = -cos.(angles)

    H = [ hamiltonian([angles[i] d_angles[i]]) for i=1:N ];

    fig = figure()
    @manipulate for t = slider(1:5:400, value=1)
        withfig(fig) do
            PyPlot.rc("figure", figsize=(12,3))
            subplot(1,2,1)
            title("Pendulum")
            plt[:axis]("off")
            xlim(-1.1,1.1)
            ylim(-1.1,1.1)
            scatter(x[1:t],y[1:t],s=5,c="grey")
            scatter([0],[0],c="black",marker="x")
            plot([0; x[t]], [0; y[t]])
            scatter(x[t:t], y[t:t],s=50,c="red")
            
            subplot(1,2,2)
            title("Hamiltonian")
            plt[:axis]("off")
            xlim(-5, 405)
            ylim(-1, 4)
            plot([1, N], [H[1], H[1]], c="yellow", linestyle="--")
            scatter(1:t, H[1:t],s=1)
            scatter([t], H[t:t],s=10,c="red")
        end
    end
end

function plot_hamiltonian(solver)
    fig = figure()
    
    angles, d_angles = solver(100000)
    H = [ hamiltonian([angles[i] d_angles[i]]) for i=1:100000 ]

    @manipulate for N = [100, 1000, 10000, 100000]
        withfig(fig) do
            PyPlot.rc("figure", figsize=(12,3))
            plot([1, N], [H[1], H[1]], c="yellow", linestyle="--")
            scatter(1:N, H[1:N], s=1);
        end
    end
end

function plot_phase_space(solver, T)
    n = 25
    x = linspace(-1,1, n)
    y = linspace(-1,1,n)

    xgrids = zeros(n,n,T+1)
    ygrids = zeros(n,n,T+1)

    for i in 1:n
        for j in 1:n
            a, da = solver(T; start=[x[i];y[j]])
            xgrids[i,j,:] = a
            ygrids[i,j,:] = da
        end
    end

    fig = figure()
    @manipulate for t = slider(1:5:T, value=1)
        withfig(fig) do
            PyPlot.rc("figure", figsize=(4,4))
            plt[:axis]("off")

            title("Phase space of the pendulum")
            
            xlim(-5, 5)
            ylim(-5, 5)
            
            scatter(xgrids[:,:,1], ygrids[:,:,1], s=1)
            scatter(xgrids[:,:,t], ygrids[:,:,t], s=1,c="red")
        end  
    end
end
