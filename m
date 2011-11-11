Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab1KKNaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:30:21 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:50894
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460Ab1KKNaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:30:16 -0500
X-SpamScore: 0
X-BigFish: VS0(zzc85fhzz1202hzz8275dhz2dh2a8h668h839h34h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 11 Nov 2011 21:41:55 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Yong Zhang <yong.zhang0@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: INFO: possible recursive locking detected: do_lookup() on 3.2-rc1
Message-ID: <20111111134153.GJ8732@S2100-06.ap.freescale.net>
References: <20111109090556.GA5949@zhy>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20111109090556.GA5949@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

[Was: Re: 3.2-rc1: INFO: possible recursive locking detected]

Here is another one.  And the .config is attached.

Regards,
Shawn

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.2.0-rc1+ (r65073@S2101-09) (gcc version 4.5.2 (Ub
untu/Linaro 4.5.2-8ubuntu3) ) #54 SMP PREEMPT Fri Nov 11 19:56:10 CST 2011
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7f
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instructio
n cache
[    0.000000] Machine: Freescale i.MX6 Quad (Device Tree), model: Freescale i.M
X6 Quad SABRE Automotive Board
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: ECC disabled, Data cache writealloc
[    0.000000] On node 0 totalpages: 524288
[    0.000000] free_area_init_node: node 0, pgdat 806c2c60, node_mem_map 80c3800
0
[    0.000000]   Normal zone: 3456 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 438912 pages, LIFO batch:31
[    0.000000]   HighMem zone: 640 pages used for memmap
[    0.000000]   HighMem zone: 81280 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 8 pages/cpu @81c5b000 s10656 r8192 d13920 u32768
[    0.000000] pcpu-alloc: s10656 r8192 d13920 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pag
es: 520192
[    0.000000] Kernel command line: console=ttymxc3,115200 debug earlyprintk roo
t=/dev/mmcblk0p3 rootwait
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Memory: 2048MB = 2048MB total
[    0.000000] Memory: 2064988k/2064988k available, 32164k reserved, 327680K hig
hmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xec800000 - 0xf4000000   ( 120 MB)
[    0.000000]     lowmem  : 0x80000000 - 0xec000000   (1728 MB)
[    0.000000]     pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
[    0.000000]     modules : 0x7f000000 - 0x7fe00000   (  14 MB)
[    0.000000]       .text : 0x80008000 - 0x806320f0   (6313 kB)
[    0.000000]       .init : 0x80633000 - 0x806749a0   ( 263 kB)
[    0.000000]       .data : 0x80676000 - 0x806c4fb0   ( 316 kB)
[    0.000000]        .bss : 0x806c4fd4 - 0x80c34880   (5567 kB)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:432
[    0.000000] L310 cache controller enabled
[    0.000000] l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL 0x02070000, Cache si
ze: 1048576 B
[    0.000000] of_irq_init: children remain, but no parents
[    0.000000] sched_clock: 32 bits at 66MHz, resolution 15ns, wraps every 65075
ms
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo
 Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.055702] Calibrating delay loop... 1581.05 BogoMIPS (lpj=7905280)
[    0.143147] pid_max: default: 32768 minimum: 301
[    0.148615] Security Framework initialized
[    0.152951] AppArmor: AppArmor initialized
[    0.157405] Mount-cache hash table entries: 512
[    0.167635] CPU: Testing write buffer coherency: ok
[    0.172770] ftrace: allocating 16849 entries in 50 pages
[    0.202113] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.208093] Calibrating local timer... 396.36MHz.
[    0.373992] CPU1: Booted secondary processor
[    0.413184] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.453729] CPU2: Booted secondary processor
[    0.493256] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.533804] CPU3: Booted secondary processor
[    0.573329] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.573424] Brought up 4 CPUs
[    0.606842] SMP: Total of 4 processors activated (6324.22 BogoMIPS).
[    0.616960] devtmpfs: initialized
[    0.633728] NET: Registered protocol family 16
[    0.649527] gpiochip_find_base: found new base at 224
[    0.657510] gpiochip_find_base: found new base at 192
[    0.664539] gpiochip_find_base: found new base at 160
[    0.671491] gpiochip_find_base: found new base at 128
[    0.678473] gpiochip_find_base: found new base at 96
[    0.685342] gpiochip_find_base: found new base at 64
[    0.692159] gpiochip_find_base: found new base at 32
[    0.706861] hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint 
registers.
[    0.715017] hw-breakpoint: maximum watchpoint size is 4 bytes.
[    0.757601] bio: create slab <bio-0> at 0
[    0.771575] NetLabel: Initializing
[    0.775116] NetLabel:  domain hash size = 128
[    0.779576] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.784948] NetLabel:  unlabeled traffic allowed by default
[    0.790688] Switching to clocksource mxc_timer1
[    0.862282] AppArmor: AppArmor Filesystem Enabled
[    0.918235] NET: Registered protocol family 2
[    0.923426] IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.932780] TCP established hash table entries: 262144 (order: 9, 2097152 byt
es)
[    0.945033] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
[    0.977742] TCP: Hash tables configured (established 262144 bind 65536)
[    0.984593] TCP reno registered
[    0.987914] UDP hash table entries: 1024 (order: 4, 98304 bytes)
[    0.994884] UDP-Lite hash table entries: 1024 (order: 4, 98304 bytes)
[    1.003124] NET: Registered protocol family 1
[    1.009301] RPC: Registered named UNIX socket transport module.
[    1.015333] RPC: Registered udp transport module.
[    1.020199] RPC: Registered tcp transport module.
[    1.025009] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.032381] Unpacking initramfs...
[    1.171869] Freeing initrd memory: 1432K
[    1.178532] audit: initializing netlink socket (disabled)
[    1.184257] type=2000 audit(1.120:1): initialized
[    1.255753] Kprobe smoke test started
[    2.085897] Kprobe smoke test passed successfully
[    2.123587] highmem bounce pool size: 64 pages
[    2.134829] Btrfs loaded
[    2.137657] msgmni has been set to 3395
[    2.144903] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 2
54)
[    2.152534] io scheduler noop registered
[    2.156590] io scheduler deadline registered
[    2.161166] io scheduler cfq registered (default)
[    2.167506] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.836264] Serial: IMX driver
[    2.840165] 21f0000.uart: ttymxc3 at MMIO 0x21f0000 (irq = 61) is a IMX
[    2.847408] console [ttymxc3] enabled, bootconsole disabled
[    2.847408] console [ttymxc3] enabled, bootconsole disabled
[    3.107010] FEC Ethernet Driver
[    3.110633] gpio_request: gpio--2 (phy-reset) status -22
[    3.135785] fec_enet_mii_bus: probed
[    3.144278] sdhci: Secure Digital Host Controller Interface driver
[    3.150512] sdhci: Copyright(c) Pierre Ossman
[    3.154880] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.161538] mxc: set GPIO 75 to high trigger
[    3.171679] mmc0: SDHCI controller on 2198000.usdhc [2198000.usdhc] using ADM
A
[    3.181123] mmc1: SDHCI controller on 219c000.usdhc [219c000.usdhc] using ADM
A
[    3.216198] oprofile: hardware counters not available
[    3.221263] oprofile: using timer interrupt.
[    3.388750] TCP cubic registered
[    3.391992] Initializing XFRM netlink socket
[    3.397040] NET: Registered protocol family 10
[    3.404235] IPv6 over IPv4 tunneling driver
[    3.410979] NET: Registered protocol family 17
[    3.415519] NET: Registered protocol family 15
[    3.420323] Registering the dns_resolver key type
[    3.425514] VFP support v0.3: implementor 41 architecture 3 part 30 variant 9
 rev 4
[    3.520947] Freeing init memory: 260K
Loading, please wait...
[    3.713140] 
[    3.714647] ======================================================
[    3.720836] [ INFO: possible circular locking dependency detected ]
[    3.727112] 3.2.0-rc1+ #54
[    3.729825] -------------------------------------------------------
[    3.736102] udevd/368 is trying to acquire lock:
[    3.740728]  (&sig->cred_guard_mutex){+.+.+.}, at: [<8013c688>] lock_trace+0x
28/0x5c
[    3.748544] 
[    3.748547] but task is already holding lock:
[    3.754398]  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<800fc954>] do_lookup
+0x1e4/0x32c
[    3.762665] 
[    3.762668] which lock already depends on the new lock.
[    3.762674] 
[    3.770879] 
[    3.770882] the existing dependency chain (in reverse order) is:
[    3.778383] 
[    3.778386] -> #1 (&sb->s_type->i_mutex_key#6){+.+.+.}:
[    3.785170]        [<8006a7d8>] __lock_acquire+0x14c4/0x1a04
[    3.790871]        [<8006b34c>] lock_acquire+0x124/0x148
[    3.796211]        [<8047999c>] mutex_lock_nested+0x5c/0x394
[    3.801903]        [<800fc954>] do_lookup+0x1e4/0x32c
[    3.806982]        [<800fcc6c>] link_path_walk+0x1d0/0x7d0
[    3.812495]        [<800fe750>] path_openat+0xac/0x374
[    3.817661]        [<800feb48>] do_filp_open+0x3c/0x88
[    3.822826]        [<800f5e98>] open_exec+0x2c/0x100
[    3.827818]        [<800f7544>] do_execve+0xd4/0x2a8
[    3.832810]        [<80011790>] sys_execve+0x44/0x64
[    3.837815]        [<8000db00>] ret_fast_syscall+0x0/0x3c
[    3.843245] 
[    3.843248] -> #0 (&sig->cred_guard_mutex){+.+.+.}:
[    3.849667]        [<80067aa4>] print_circular_bug+0x68/0x2b8
[    3.855445]        [<8006a5ac>] __lock_acquire+0x1298/0x1a04
[    3.861132]        [<8006b34c>] lock_acquire+0x124/0x148
[    3.866470]        [<804791a8>] mutex_lock_killable_nested+0x60/0x464
[    3.872940]        [<8013c688>] lock_trace+0x28/0x5c
[    3.877932]        [<8013e79c>] proc_lookupfd_common+0x60/0xc8
[    3.883795]        [<8013e844>] proc_lookupfd+0x1c/0x24
[    3.889047]        [<800fa96c>] d_alloc_and_lookup+0x54/0x70
[    3.894738]        [<800fc978>] do_lookup+0x208/0x32c
[    3.899816]        [<800fd434>] path_lookupat+0xfc/0x6c8
[    3.905155]        [<800fda2c>] do_path_lookup+0x2c/0x68
[    3.910495]        [<800feab0>] user_path_at_empty+0x68/0x98
[    3.916181]        [<800feb04>] user_path_at+0x24/0x2c
[    3.921346]        [<800f4eb4>] vfs_fstatat+0x44/0x74
[    3.926425]        [<800f4f40>] vfs_stat+0x2c/0x30
[    3.931243]        [<800f5164>] sys_stat64+0x24/0x40
[    3.936234]        [<8000db00>] ret_fast_syscall+0x0/0x3c
[    3.941662] 
[    3.941666] other info that might help us debug this:
[    3.941671] 
[    3.949702]  Possible unsafe locking scenario:
[    3.949708] 
[    3.955644]        CPU0                    CPU1
[    3.960181]        ----                    ----
[    3.964718]   lock(&sb->s_type->i_mutex_key);
[    3.969114]                                lock(&sig->cred_guard_mutex);
[    3.975853]                                lock(&sb->s_type->i_mutex_key);
[    3.982766]   lock(&sig->cred_guard_mutex);
[    3.986984] 
[    3.986987]  *** DEADLOCK ***
[    3.986991] 
[    3.992941] 1 lock held by udevd/368:
[    3.996609]  #0:  (&sb->s_type->i_mutex_key#6){+.+.+.}, at: [<800fc954>] do_l
ookup+0x1e4/0x32c
[    4.005314] 
[    4.005317] stack backtrace:
[    4.009712] [<800151dc>] (unwind_backtrace+0x0/0xec) from [<80477088>] (dump_
stack+0x20/0x24)
[    4.018260] [<80477088>] (dump_stack+0x20/0x24) from [<80067ca8>] (print_circ
ular_bug+0x26c/0x2b8)
[    4.027242] [<80067ca8>] (print_circular_bug+0x26c/0x2b8) from [<8006a5ac>] (
__lock_acquire+0x1298/0x1a04)
[    4.036918] [<8006a5ac>] (__lock_acquire+0x1298/0x1a04) from [<8006b34c>] (lo
ck_acquire+0x124/0x148)
[    4.046072] [<8006b34c>] (lock_acquire+0x124/0x148) from [<804791a8>] (mutex_
lock_killable_nested+0x60/0x464)
[    4.056007] [<804791a8>] (mutex_lock_killable_nested+0x60/0x464) from [<8013c
688>] (lock_trace+0x28/0x5c)
[    4.065593] [<8013c688>] (lock_trace+0x28/0x5c) from [<8013e79c>] (proc_looku
pfd_common+0x60/0xc8)
[    4.074572] [<8013e79c>] (proc_lookupfd_common+0x60/0xc8) from [<8013e844>] (
proc_lookupfd+0x1c/0x24)
[    4.083812] [<8013e844>] (proc_lookupfd+0x1c/0x24) from [<800fa96c>] (d_alloc
_and_lookup+0x54/0x70)
[    4.092878] [<800fa96c>] (d_alloc_and_lookup+0x54/0x70) from [<800fc978>] (do
_lookup+0x208/0x32c)
[    4.101771] [<800fc978>] (do_lookup+0x208/0x32c) from [<800fd434>] (path_look
upat+0xfc/0x6c8)
[    4.110317] [<800fd434>] (path_lookupat+0xfc/0x6c8) from [<800fda2c>] (do_pat
h_lookup+0x2c/0x68)
[    4.119123] [<800fda2c>] (do_path_lookup+0x2c/0x68) from [<800feab0>] (user_p
ath_at_empty+0x68/0x98)
[    4.128275] [<800feab0>] (user_path_at_empty+0x68/0x98) from [<800feb04>] (us
er_path_at+0x24/0x2c)
[    4.137253] [<800feb04>] (user_path_at+0x24/0x2c) from [<800f4eb4>] (vfs_fsta
tat+0x44/0x74)
[    4.145621] [<800f4eb4>] (vfs_fstatat+0x44/0x74) from [<800f4f40>] (vfs_stat+
0x2c/0x30)
[    4.153642] [<800f4f40>] (vfs_stat+0x2c/0x30) from [<800f5164>] (sys_stat64+0
x24/0x40)
[    4.161579] [<800f5164>] (sys_stat64+0x24/0x40) from [<8000db00>] (ret_fast_s
yscall+0x0/0x3c)
[    4.173173] udevd[369]: starting version 173
[    4.585095] mmc0: new high speed SDHC card at address aaaa
[    4.591330] mmcblk0: mmc0:aaaa SD04G 3.69 GiB 
[    4.597998]  mmcblk0: p1 p2 p3
[    5.384460] mmc1: host does not support reading read-only switch. assuming wr
ite-enable.
[    5.796502] mmc1: new high speed SDHC card at address 1234
[    5.803063] mmcblk1: mmc1:1234 SA04G 3.68 GiB 
[    5.810156]  mmcblk1: p1 p2 p3
[    6.032487] EXT4-fs (mmcblk0p3): INFO: recovery required on readonly filesyst
em
[    6.039849] EXT4-fs (mmcblk0p3): write access will be enabled during recovery
[    6.064099] EXT4-fs (mmcblk0p3): recovery complete
[    6.074078] EXT4-fs (mmcblk0p3): mounted filesystem with ordered data mode. O
pts: (null)

Last login: Thu Jan  1 00:00:27 UTC 1970 on tty1
Welcome to Linaro 11.10 (development branch) (GNU/Linux 3.2.0-rc1+ armv7l)

 * Documentation:  https://wiki.linaro.org/
root@linaro-nano:~# 

--ibTvN161/egqYuK8
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename=".config"

#
# Automatically generated file; DO NOT EDIT.
# Linux/arm 3.2.0-rc1 Kernel Configuration
#
CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_HAVE_SCHED_CLOCK=y
CONFIG_GENERIC_GPIO=y
# CONFIG_ARCH_USES_GETTIMEOFFSET is not set
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_KTIME_SCALAR=y
CONFIG_HAVE_PROC_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_LOCKBREAK=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_ARM_PATCH_PHYS_VIRT=y
CONFIG_GENERIC_BUG=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# System Type
#
CONFIG_MMU=y
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_VEXPRESS is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_BCMRING is not set
# CONFIG_ARCH_HIGHBANK is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_CNS3XXX is not set
# CONFIG_ARCH_GEMINI is not set
# CONFIG_ARCH_PRIMA2 is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
CONFIG_ARCH_MXC=y
# CONFIG_ARCH_MXS is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_H720X is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP23XX is not set
# CONFIG_ARCH_IXP2000 is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_DOVE is not set
# CONFIG_ARCH_KIRKWOOD is not set
# CONFIG_ARCH_LPC32XX is not set
# CONFIG_ARCH_MV78XX0 is not set
# CONFIG_ARCH_ORION5X is not set
# CONFIG_ARCH_MMP is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_W90X900 is not set
# CONFIG_ARCH_TEGRA is not set
# CONFIG_ARCH_PICOXCELL is not set
# CONFIG_ARCH_PNX4008 is not set
# CONFIG_ARCH_PXA is not set
# CONFIG_ARCH_MSM is not set
# CONFIG_ARCH_SHMOBILE is not set
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C2410 is not set
# CONFIG_ARCH_S3C64XX is not set
# CONFIG_ARCH_S5P64X0 is not set
# CONFIG_ARCH_S5PC100 is not set
# CONFIG_ARCH_S5PV210 is not set
# CONFIG_ARCH_EXYNOS is not set
# CONFIG_ARCH_SHARK is not set
# CONFIG_ARCH_TCC_926 is not set
# CONFIG_ARCH_U300 is not set
# CONFIG_ARCH_U8500 is not set
# CONFIG_ARCH_NOMADIK is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP is not set
# CONFIG_PLAT_SPEAR is not set
# CONFIG_ARCH_VT8500 is not set
# CONFIG_ARCH_ZYNQ is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set

#
# Freescale MXC Implementations
#
# CONFIG_ARCH_IMX_V4_V5 is not set
CONFIG_ARCH_IMX_V6_V7=y
# CONFIG_ARCH_MX5 is not set
CONFIG_HAVE_IMX_GPC=y
CONFIG_HAVE_IMX_MMDC=y
CONFIG_HAVE_IMX_SRC=y

#
# MX31 platforms:
#
# CONFIG_MACH_MX31ADS is not set
# CONFIG_MACH_MX31LILLY is not set
# CONFIG_MACH_MX31LITE is not set
# CONFIG_MACH_PCM037 is not set
# CONFIG_MACH_MX31_3DS is not set
# CONFIG_MACH_MX31MOBOARD is not set
# CONFIG_MACH_QONG is not set
# CONFIG_MACH_ARMADILLO5X0 is not set
# CONFIG_MACH_KZM_ARM11_01 is not set
# CONFIG_MACH_BUG is not set

#
# MX35 platforms:
#
# CONFIG_MACH_PCM043 is not set
# CONFIG_MACH_MX35_3DS is not set
# CONFIG_MACH_EUKREA_CPUIMX35 is not set
# CONFIG_MACH_VPR200 is not set

#
# i.MX6 family:
#
CONFIG_SOC_IMX6Q=y
# CONFIG_MXC_IRQ_PRIOR is not set
# CONFIG_MXC_PWM is not set
CONFIG_MXC_DEBUG_BOARD=y

#
# System MMU
#

#
# Processor Type
#
CONFIG_CPU_V7=y
CONFIG_CPU_32v6K=y
CONFIG_CPU_32v7=y
CONFIG_CPU_ABRT_EV7=y
CONFIG_CPU_PABRT_V7=y
CONFIG_CPU_CACHE_V7=y
CONFIG_CPU_CACHE_VIPT=y
CONFIG_CPU_COPY_V6=y
CONFIG_CPU_TLB_V7=y
CONFIG_CPU_HAS_ASID=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y

#
# Processor Features
#
CONFIG_ARM_THUMB=y
# CONFIG_ARM_THUMBEE is not set
# CONFIG_SWP_EMULATE is not set
# CONFIG_CPU_ICACHE_DISABLE is not set
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_CPU_BPREDICT_DISABLE is not set
CONFIG_OUTER_CACHE=y
CONFIG_OUTER_CACHE_SYNC=y
CONFIG_CACHE_L2X0=y
CONFIG_CACHE_PL310=y
CONFIG_ARM_L1_CACHE_SHIFT=5
CONFIG_ARM_DMA_MEM_BUFFERABLE=y
CONFIG_CPU_HAS_PMU=y
CONFIG_MULTI_IRQ_HANDLER=y
# CONFIG_ARM_ERRATA_430973 is not set
# CONFIG_ARM_ERRATA_458693 is not set
# CONFIG_ARM_ERRATA_460075 is not set
# CONFIG_ARM_ERRATA_742230 is not set
# CONFIG_ARM_ERRATA_742231 is not set
# CONFIG_PL310_ERRATA_588369 is not set
# CONFIG_ARM_ERRATA_720789 is not set
# CONFIG_PL310_ERRATA_727915 is not set
# CONFIG_ARM_ERRATA_743622 is not set
# CONFIG_ARM_ERRATA_751472 is not set
# CONFIG_ARM_ERRATA_753970 is not set
# CONFIG_ARM_ERRATA_754322 is not set
# CONFIG_ARM_ERRATA_754327 is not set
# CONFIG_ARM_ERRATA_764369 is not set
CONFIG_ARM_GIC=y

#
# Bus support
#
# CONFIG_PCI_SYSCALL is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCCARD is not set

#
# Kernel Features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SMP_ON_UP=y
CONFIG_ARM_CPU_TOPOLOGY=y
# CONFIG_SCHED_MC is not set
# CONFIG_SCHED_SMT is not set
CONFIG_HAVE_ARM_SCU=y
CONFIG_HAVE_ARM_TWD=y
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_NR_CPUS=4
CONFIG_HOTPLUG_CPU=y
CONFIG_LOCAL_TIMERS=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_HZ=100
# CONFIG_THUMB2_KERNEL is not set
CONFIG_AEABI=y
CONFIG_OABI_COMPAT=y
# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
CONFIG_HAVE_ARCH_PFN_VALID=y
CONFIG_HIGHMEM=y
# CONFIG_HIGHPTE is not set
# CONFIG_HW_PERF_EVENTS is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=32768
# CONFIG_CLEANCACHE is not set
CONFIG_FORCE_MAX_ZONEORDER=11
CONFIG_ALIGNMENT_TRAP=y
# CONFIG_UACCESS_WITH_MEMCPY is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_DEPRECATED_PARAM_STRUCT is not set

#
# Boot options
#
CONFIG_USE_OF=y
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_ARM_APPENDED_DTB=y
CONFIG_ARM_APPENDED_DTB_FILE="arch/arm/boot/imx6q-sabreauto.dtb"
CONFIG_ARM_ATAG_DTB_COMPAT=y
CONFIG_CMDLINE=""
# CONFIG_XIP_KERNEL is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_AUTO_ZRELADDR=y

#
# CPU Power Management
#
# CONFIG_CPU_IDLE is not set

#
# Floating point emulation
#

#
# At least one emulation must be selected
#
# CONFIG_FPE_NWFPE is not set
# CONFIG_FPE_FASTFPE is not set
CONFIG_VFP=y
CONFIG_VFPv3=y
# CONFIG_NEON is not set

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Power management options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_APM_EMULATION is not set
CONFIG_PM_CLK=y
CONFIG_CPU_PM=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARM_CPU_SUSPEND=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_L2CAP is not set
# CONFIG_BT_SCO is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_GPIO=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_MII=y
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_DM9000 is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_FARADAY is not set
CONFIG_NET_VENDOR_FREESCALE=y
CONFIG_FEC=y
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_IMX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_IMX=y
CONFIG_SERIAL_IMX_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_HVC_DCC is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_R3964 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_RAMOOPS is not set
# CONFIG_I2C is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
# CONFIG_PINCTRL is not set
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_MXC=y

#
# I2C GPIO expanders:
#

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_ASIC3 is not set
# CONFIG_HTC_EGPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_T7L66XB is not set
# CONFIG_MFD_TC6387XB is not set
# CONFIG_MFD_TC6393XB is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
# CONFIG_FB_CFB_FILLRECT is not set
# CONFIG_FB_CFB_COPYAREA is not set
# CONFIG_FB_CFB_IMAGEBLIT is not set
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_ESDHC_IMX=y
# CONFIG_MMC_SDHCI_PXAV3 is not set
# CONFIG_MMC_SDHCI_PXAV2 is not set
# CONFIG_MMC_MXC is not set
# CONFIG_MMC_DW is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set
# CONFIG_STAGING is not set
CONFIG_CLKDEV_LOOKUP=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_MMIO=y
# CONFIG_IOMMU_SUPPORT is not set
# CONFIG_VIRT_DRIVERS is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_ARM_UNWIND=y
CONFIG_OLD_MCOUNT=y
CONFIG_DEBUG_USER=y
CONFIG_DEBUG_LL=y
# CONFIG_DEBUG_LL_UART_NONE is not set
# CONFIG_DEBUG_ICEDCC is not set
CONFIG_DEBUG_IMX6Q_UART=y
CONFIG_EARLY_PRINTK=y
# CONFIG_ARM_KPROBES_TEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set

--ibTvN161/egqYuK8--
