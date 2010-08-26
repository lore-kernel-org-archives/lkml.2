Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab0HZL0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:26:22 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60418 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0HZL0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:26:19 -0400
Message-ID: <4C764F52.5050707@linux.vnet.ibm.com>
Date: Thu, 26 Aug 2010 16:56:10 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org
Subject: Power machines fail to boot after build being successful
Content-Type: multipart/mixed;
 boundary="------------060402090502050601040804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060402090502050601040804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

After successfully building the kernel version 2.6.36-rc2-git4(commitid d4348c678977c) with the config file attached(used make oldconfig),
P5 and P6 power machines fails to reboot with the following logs

Logs collected while rebooting into today next, same occurs with the upstream kernel too.

Please wait, loading kernel...
Allocated 01a00000 bytes for kernel @ 03500000
    Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 00841ae7 @ 04f00000
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.36-rc2-autotest-next-20100826 (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Thu Aug 26 10:55:01 IST 2010
Max number of cores passed to firmware: 512 (NR_CPUS = 1024)
Calling ibm,client-architecture-support... done
command line: root=/dev/sda5 IDENT=1282801372 xmon=early
memory layout at init:
   memory_limit : 0000000000000000 (16 MB aligned)
   alloc_bottom : 0000000005750000
   alloc_top    : 0000000008000000
   alloc_top_hi : 0000000008000000
   rmo_top      : 0000000008000000
   ram_top      : 0000000008000000
instantiating rtas at 0x00000000074e0000... done
boot cpu hw idx 0
starting cpu hw idx 2... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000005760000 ->  0x00000000057615fa
Device tree struct  0x0000000005770000 ->  0x0000000005790000
Calling quiesce...
returning from prom_init
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000004f00000:0xc000000005741ae7
Partition configured for 4 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Thu Aug 26 10:55:01 IST 2010
-----------------------------------------------------
ppc64_pft_size                = 0x1a
physicalMemorySize            = 0x100000000
htab_hash_mask                = 0x7ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.36-rc2-autotest-next-20100826 (root@llm62) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Thu Aug 26 10:55:01 IST 2010
[boot]0012 Setup Arch
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
   DMA      0x00000000 ->  0x00010000
   Normal   empty
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     1: 0x00000000 ->  0x00010000
Could not find start_pfn for node 0
[boot]0015 Setup Done
PERCPU: Embedded 29 pages/cpu @c000000002100000 s1859840 r0 d40704 u2097152
pcpu-alloc: s1859840 r0 d40704 u2097152 alloc=2*1048576
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 65480
Policy zone: DMA
Kernel command line: root=/dev/sda5 IDENT=1282801372 xmon=early
PID hash table entries: 4096 (order: -1, 32768 bytes)
freeing bootmem node 1
Memory: 4124352k/4194304k available (10880k kernel code, 69952k reserved, 2880k data, 10947k bss, 2432k init)
Hierarchical RCU implementation.
         Verbose stalled-CPUs detection is disabled.
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
clocksource: timebase mult[7d0000] shift[22] registered
Console: colour dummy device 80x25
console [hvc0] enabled, bootconsole disabled
console [hvc0] enabled, bootconsole disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 6335 kB
  per task-struct memory footprint: 2688 bytes
allocated 2621440 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
AppArmor: AppArmor disabled by boot time parameter
Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
cpu 0x1: Vector: 300 (Data Access) at [c0000000fedcbd10]
     pc: 0000000000017f00
     lr: 0000000000008290
     sp: c0000000fedcbf90
    msr: 8000000000001000
    dar: c0000000fedcbfa0
  dsisr: 42000000
   current = 0xc0000000fedb4e70
   paca    = 0xc000000007440280
     pid   = 0, comm = swapper
WARNING: exception is not recoverable, can't continue
enter ? for help
1:mon>  Unable to handle kernel paging request for data at address 0xc0000000fedcbfa0
Faulting instruction address: 0x00017f00
Processor 1 is stuck.
cpu 0x2: Vector: 300 (Data Access) at [c0000000fedcfd10]
     pc: 0000000000017f00
     lr: 0000000000008290
     sp: c0000000fedcff90
    msr: 8000000000001002
    dar: c0000000fedcffa0
  dsisr: 42000000
   current = 0xc0000000fedb7580
   paca    = 0xc000000007440500
     pid   = 0, comm = swapper
Unable to handle kernel paging request for data at address 0xc0000000fedcffa0
Faulting instruction address: 0x00017f00
Processor 2 is stuck.
cpu 0x3: Vector: 300 (Data Access) at [c0000000fee33d10]
     pc: 0000000000017f00
     lr: 0000000000008290
     sp: c0000000fee33f90
    msr: 8000000000001000
    dar: c0000000fee33fa0
  dsisr: 42000000
   current = 0xc0000000fedb9c90
   paca    = 0xc000000007440780
     pid   = 0, comm = swapper
WARNING: exception is not recoverable, can't continue

Thanks
Divya


--------------060402090502050601040804
Content-Type: text/plain;
 name="config_ppc_slub"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config_ppc_slub"

CONFIG_ALTIVEC=y
# CONFIG_WIRELESS is not set
CONFIG_VSX=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KPROBES=y
CONFIG_CMM=y
CONFIG_PPC_HAS_HASH_64K=y
CONFIG_PPC_64K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=9
CONFIG_PPC_SUBPAGE_PROT=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_KEXEC=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_IBMEBUS=y
CONFIG_EHEA=y
CONFIG_SCSI_IBMVSCSI=y
CONFIG_SCSI_IBMVFC=m
CONFIG_SCSI_IPR=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
ONFIG_BLK_DEV_IO_TRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_LOCALVERSION_AUTO=n
CONFIG_LOCALVERSION=""
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_HAVE_PERF_COUNTERS=y
CONFIG_PERF_COUNTERS=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_FSNOTIFY=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_PERF_EVENTS=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEBUG_CFQ_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_VIRTUALIZATION=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_NR_IRQS=512
CONFIG_MIGRATION=y
CONFIG_KSM=y
CONFIG_PM=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_LOCK_STAT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_IXGBE_DCB=y
CONFIG_DCB=y


--------------060402090502050601040804--
