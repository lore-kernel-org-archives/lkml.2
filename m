Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0IPG7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:59:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:18267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0IPG71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:59:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,375,1280732400"; 
   d="scan'208";a="554996524"
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Huang Ying <ying.huang@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20100915085003.GA20697@console-pimps.org>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	 <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
	 <1284377790.2275.212.camel@laptop>
	 <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
	 <1284539320.3764.266.camel@twins>
	 <20100915085003.GA20697@console-pimps.org>
Content-Type: multipart/mixed; boundary="=-JY4V+1DsyOs8480myzk5"
Date: Thu, 16 Sep 2010 14:59:22 +0800
Message-ID: <1284620363.2754.430.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JY4V+1DsyOs8480myzk5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2010-09-15 at 16:50 +0800, Matt Fleming wrote:
> On Wed, Sep 15, 2010 at 10:28:40AM +0200, Peter Zijlstra wrote:
> > 
> > I've got a patch to solve the Alpha issue, and I've got a patch for one
> > of the SH issues as well, but I understand you need to pull in Paul
> > Mundt's SH tree to make it fully build.
> 
> FWIW this is the commit that is missing in Linus' tree which fixes the
> build issues,
> 
> http://git.kernel.org/?p=linux/kernel/git/lethal/sh-2.6.git;a=commit;h=b9afa3e015273a52718e0a7efe198a0df76be880
> 
> I'm guessing Paul will be sending a pull request to fix this breakage
> before 2.6.36 is released.

I have compile error even after merging full sh-2.6.git. Log is
attached. I need a newer compiler?

Best Regards,
Huang Ying


--=-JY4V+1DsyOs8480myzk5
Content-Disposition: attachment; filename="log_sh4"
Content-Type: text/plain; name="log_sh4"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

make -C /home/caritas/projects/mce/kernel/linux-mce.git O=/home/caritas/projects/mce/kernel/build-cross/obj-sh4/. 
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-sh4/Makefile
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig arch/sh/Kconfig
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-sh4/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  Using /home/caritas/projects/mce/kernel/linux-mce.git as source for kernel
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/pnmtologo
  HOSTCC  scripts/conmakehash
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  Generating include/generated/machtypes.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  CC      arch/sh/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/caritas/projects/mce/kernel/linux-mce.git/scripts/checksyscalls.sh
  HOSTLD  scripts/mod/modpost
  LD      usr/built-in.o
  CHK     include/generated/compile.h
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/do_mounts_rd.o
  CC      arch/sh/kernel/clkdev.o
  CC      init/noinitramfs.o
  AS      arch/sh/kernel/debugtraps.o
  CC      arch/sh/kernel/dma-nommu.o
  CC      arch/sh/mm/alignment.o
  CC      arch/sh/mm/cache.o
  CC      arch/sh/kernel/dumpstack.o
  CC      arch/sh/mm/init.o
  CC      arch/sh/mm/consistent.o
  CC      arch/sh/kernel/idle.o
  LD      arch/sh/boards/built-in.o
  CC      arch/sh/kernel/io.o
  CC      arch/sh/mm/mmap.o
  CC      arch/sh/kernel/irq.o
  CC      arch/sh/mm/cache-sh2.o
  CC      arch/sh/mm/nommu.o
  CC      arch/sh/mm/extable_32.o
  CC      arch/sh/mm/asids-debugfs.o
  CC      kernel/sched.o
  CC      arch/sh/kernel/irq_32.o
  CC      arch/sh/mm/uncached.o
  CC      arch/sh/kernel/machvec.o
  CC      kernel/fork.o
  CC      mm/bootmem.o
  CC      kernel/exec_domain.o
  CC      arch/sh/kernel/nmi_debug.o
  CC      mm/filemap.o
  CC      kernel/panic.o
  CC      kernel/printk.o
  CC      arch/sh/kernel/process.o
  CC      mm/mempool.o
  UPD     include/generated/compile.h
  CC      kernel/cpu.o
  CC      mm/oom_kill.o
  CC      arch/sh/kernel/process_32.o
  CC      arch/sh/kernel/ptrace.o
  CC      kernel/exit.o
  CC      arch/sh/kernel/ptrace_32.o
  CC      mm/fadvise.o
  CC      kernel/itimer.o
  TIMEC   kernel/timeconst.h
  CC      mm/maccess.o
  CC      arch/sh/kernel/reboot.o
  CC      kernel/softirq.o
  CC      init/version.o
  CC      arch/sh/kernel/return_address.o
  CC      mm/page_alloc.o
  CC      arch/sh/kernel/setup.o
  CC      kernel/resource.o
  CC      mm/page-writeback.o
  CC      arch/sh/kernel/signal_32.o
  CC      kernel/sysctl.o
  CC      mm/readahead.o
  CC      kernel/sysctl_binary.o
  CC      arch/sh/kernel/sys_sh.o
  CC      kernel/capability.o
  CC      mm/swap.o
  CC      mm/truncate.o
  CC      kernel/ptrace.o
  CC      arch/sh/kernel/sys_sh32.o
  CC      mm/vmscan.o
  CC      ipc/mqueue.o
  CC      security/commoncap.o
  CC      fs/open.o
  CC      kernel/timer.o
  AS      arch/sh/kernel/syscalls_32.o
  CC      arch/sh/kernel/time.o
  CC      kernel/user.o
  CC      arch/sh/kernel/topology.o
  CC      ipc/msgutil.o
  CC      arch/sh/kernel/traps.o
  CC      arch/sh/kernel/traps_32.o
/home/caritas/projects/mce/kernel/linux-mce.git/mm/bootmem.c: In function 'mark_bootmem':
/home/caritas/projects/mce/kernel/linux-mce.git/mm/bootmem.c:421: warning: control reaches end of non-void function
  CC      kernel/signal.o
  CC      arch/sh/kernel/unwinder.o
  CC      crypto/api.o
  CC      arch/sh/kernel/cpu/irq/imask.o
  CC      kernel/sys.o
  CC      arch/sh/kernel/sh_ksyms_32.o
  CC      kernel/kmod.o
  CC      arch/sh/kernel/module.o
  AS      arch/sh/kernel/cpu/sh2/ex.o
  CC      arch/sh/kernel/disassemble.o
  CC      block/elevator.o
  CC      arch/sh/kernel/perf_event.o
  CC      mm/shmem.o
  CC      arch/sh/kernel/cpu/sh2/probe.o
  CC      arch/sh/kernel/perf_callchain.o
  AS      arch/sh/kernel/cpu/sh2/entry.o
  CC      arch/sh/kernel/io_generic.o
  CC      kernel/workqueue.o
  CC      arch/sh/kernel/hw_breakpoint.o
  AS      arch/sh/kernel/head_32.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S: Assembler messages:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:60: Error: offset out of range
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:60: Error: value of 4294967280 too large for field of 2 bytes at 408
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:178: Error: offset out of range
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:178: Error: value of 4294967280 too large for field of 2 bytes at 598
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:326: Error: offset out of range
/home/caritas/projects/mce/kernel/linux-mce.git/arch/sh/kernel/cpu/sh2/../../entry-common.S:326: Error: value of 4294967280 too large for field of 2 bytes at 754
make[5]: *** [arch/sh/kernel/cpu/sh2/entry.o] Error 1
make[5]: *** Waiting for unfinished jobs....
  CC      mm/prio_tree.o
  CC      arch/sh/kernel/init_task.o
  CC      block/blk-core.o
  LD      arch/sh/mm/built-in.o
make[4]: *** [arch/sh/kernel/cpu/sh2] Error 2
make[4]: *** Waiting for unfinished jobs....
  LDS     arch/sh/kernel/vmlinux.lds
  CC      mm/util.o
  CC      mm/mmzone.o
  CC      ipc/mq_sysctl.o
  CC      crypto/cipher.o
  CC      kernel/pid.o
  LD      arch/sh/kernel/cpu/irq/built-in.o
  LD      sound/built-in.o
make[3]: *** [arch/sh/kernel/cpu] Error 2
make[3]: *** Waiting for unfinished jobs....
  CC      crypto/compress.o
  CC      kernel/rcupdate.o
  CC      crypto/algapi.o
  CC      kernel/extable.o
  CC      mm/vmstat.o
  CC      fs/read_write.o
  CC      block/blk-tag.o
  CC      fs/file_table.o
  CC      block/blk-sysfs.o
  LD      firmware/built-in.o
  CC      mm/backing-dev.o
  CC      mm/page_isolation.o
  CC      kernel/params.o
  LD      drivers/auxdisplay/built-in.o
  LD      arch/sh/drivers/dma/built-in.o
  LD      init/mounts.o
  CC      arch/sh/drivers/heartbeat.o
  LD      init/built-in.o
  CC      drivers/base/core.o
  CC      kernel/posix-timers.o
  CC      kernel/kthread.o
  CC      crypto/scatterwalk.o
  CC      mm/mm_init.o
  CC      net/socket.o
  CC      mm/mmu_context.o
  CC      crypto/proc.o
  CC      crypto/ablkcipher.o
  CC      arch/sh/lib/io.o
  CC      mm/nommu.o
  CC      fs/super.o
  CC      mm/init-mm.o
  CC      kernel/wait.o
  CC      kernel/kfifo.o
  LD      security/built-in.o
  CC      drivers/base/sys.o
  CC      mm/memblock.o
  CC      crypto/blkcipher.o
  CC      drivers/block/brd.o
  CC      crypto/ahash.o
  CC      lib/bcd.o
  CC      kernel/sys_ni.o
  AS      arch/sh/lib/ashiftrt.o
  CC      kernel/posix-cpu-timers.o
  CC      mm/dmapool.o
  CC      crypto/shash.o
  CC      kernel/mutex.o
  CC      fs/char_dev.o
  CC      arch/sh/lib/ashldi3.o
  CC      mm/slab.o
  CC      kernel/hrtimer.o
  CC      kernel/rwsem.o
  CC      mm/percpu_up.o
  CC      drivers/base/bus.o
  CC      mm/quicklist.o
  CC      kernel/nsproxy.o
  AS      arch/sh/lib/ashlsi3.o
  CC      lib/div64.o
  CC      arch/sh/lib/ashrdi3.o
  CC      drivers/base/dd.o
  AS      arch/sh/lib/ashrsi3.o
  AS      arch/sh/lib/checksum.o
  CC      drivers/block/loop.o
  CC      arch/sh/lib/delay.o
make[2]: *** [arch/sh/kernel] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC      arch/sh/lib/div64-generic.o
  CC      lib/sort.o
  LD      net/802/built-in.o
  AS      arch/sh/lib/div64.o
  CC      block/blk-barrier.o
  CC      kernel/srcu.o
  LD      arch/sh/drivers/built-in.o
  CC      fs/stat.o
  CC      net/core/sock.o
  CC      arch/sh/lib/lshrdi3.o
  CC      kernel/semaphore.o
  AS      arch/sh/lib/lshrsi3.o
  CC      kernel/notifier.o
  AS      arch/sh/lib/memchr.o
  CC      crypto/algboss.o
  CC      kernel/ksysfs.o
  CC      block/blk-settings.o
  CC      kernel/pm_qos_params.o
  LD      drivers/cdrom/built-in.o
  CC      kernel/sched_clock.o
  CC      drivers/char/mem.o
  CC      drivers/clocksource/sh_cmt.o
  CC      crypto/testmgr.o
  CC      lib/parser.o
  CC      block/blk-ioc.o
  CC      drivers/base/driver.o
  LD      drivers/crypto/built-in.o
  CC      crypto/crypto_wq.o
  AS      arch/sh/lib/memcpy.o
  CC      kernel/cred.o
  CC      lib/halfmd4.o
  LD      drivers/firmware/built-in.o
  AS      arch/sh/lib/memmove.o
  CC      fs/exec.o
  CC      lib/debug_locks.o
  CC      kernel/async.o
  AS      arch/sh/lib/memset.o
  CC      crypto/aead.o
  AS      arch/sh/lib/movmem.o
  LD      drivers/gpio/built-in.o
  CC      crypto/chainiv.o
  CC      fs/pipe.o
  CC      crypto/eseqiv.o
  AS      arch/sh/lib/strlen.o
  AS      arch/sh/lib/udiv_qrnnd.o
  CC      kernel/range.o
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/pm_qos_params.c: In function 'pm_qos_get_value':
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/pm_qos_params.c:132: warning: control reaches end of non-void function
  AS      arch/sh/lib/udivsi3.o
  AS      arch/sh/lib/udivsi3_i4i-Os.o
  CC      fs/namei.o
  LD      arch/sh/lib/built-in.o
  LD      drivers/gpu/drm/i2c/built-in.o
  CC      kernel/groups.o
  CC      block/blk-map.o
  CC      crypto/pcompress.o
  AR      arch/sh/lib/lib.a
  LD      drivers/gpu/vga/built-in.o
  LD      drivers/gpu/drm/built-in.o
  CC      crypto/md5.o
  CC      kernel/irq/handle.o
  CC      kernel/futex.o
  CC      lib/random32.o
  CC      kernel/irq/manage.o
  LD      drivers/gpu/built-in.o
  CC      kernel/rtmutex.o
  CC      lib/bust_spinlocks.o
  CC      kernel/time/timekeeping.o
  CC      kernel/irq/spurious.o
  CC      block/blk-exec.o
  CC      lib/hexdump.o
  CC      drivers/base/class.o
  CC      crypto/cbc.o
  CC      drivers/base/platform.o
  CC      lib/kasprintf.o
  CC      kernel/time/ntp.o
  CC      drivers/base/cpu.o
  CC      drivers/base/firmware.o
  CC      drivers/base/init.o
  CC      kernel/up.o
  CC      drivers/hid/hid-core.o
  CC      crypto/des_generic.o
  CC      kernel/uid16.o
  CC      drivers/char/random.o
  CC      kernel/module.o
  CC      fs/fcntl.o
  CC      fs/ioctl.o
  CC      kernel/kallsyms.o
  CC      block/blk-merge.o
  CC      net/core/request_sock.o
  CC      crypto/rng.o
  CC      fs/readdir.o
  CC      crypto/krng.o
  CC      kernel/hung_task.o
  LD      ipc/built-in.o
  LD      drivers/clocksource/built-in.o
  CC      block/blk-softirq.o
  CC      drivers/hwmon/hwmon.o
  CC      kernel/rcutree.o
  CC      drivers/base/map.o
  CC      lib/bitmap.o
  CC      kernel/irq/resend.o
  CC      lib/scatterlist.o
  CC      drivers/i2c/i2c-boardinfo.o
  CC      block/blk-timeout.o
  CC      block/blk-iopoll.o
  CC      drivers/base/devres.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/elfcore.o
  CC      drivers/base/attribute_container.o
  CC      lib/string_helpers.o
  CC      drivers/base/transport_class.o
  CC      lib/gcd.o
  CC      kernel/perf_event.o
  LD      crypto/crypto.o
  LD      crypto/crypto_algapi.o
  LD      crypto/crypto_blkcipher.o
  CC      kernel/hw_breakpoint.o
  LD      crypto/crypto_hash.o
  LD      crypto/cryptomgr.o
  CC      fs/select.o
  CC      fs/fifo.o
  CC      drivers/hid/hid-input.o
  CC      net/core/skbuff.o
  LD      drivers/idle/built-in.o
  LD      drivers/base/power/built-in.o
  CC      fs/dcache.o
  CC      drivers/base/dma-mapping.o
  LD      drivers/ieee1394/built-in.o
  CC      drivers/char/tty_io.o
  CC      lib/lcm.o
  CC      kernel/time.o
  LD      drivers/block/built-in.o
  CC      lib/list_sort.o
  CC      kernel/irq/chip.o
  LD      drivers/ieee802154/built-in.o
  CC      lib/uuid.o
  LD      drivers/i2c/algos/built-in.o
  LD      drivers/hwmon/built-in.o
  CC      block/blk-lib.o
  CC      net/ethernet/eth.o
  CC      drivers/base/dma-coherent.o
  LD      drivers/lguest/built-in.o
  LD      drivers/macintosh/built-in.o
  CC      drivers/input/input.o
  LD      drivers/i2c/busses/built-in.o
  CC      lib/iomap_copy.o
  CC      kernel/irq/devres.o
  CC      block/ioctl.o
  CC      kernel/irq/proc.o
  CC      block/genhd.o
  CC      net/ipv4/route.o
  LD      drivers/mfd/built-in.o
  LD      drivers/i2c/muxes/built-in.o
  CC [M]  drivers/i2c/i2c-core.o
  CC      drivers/hid/hid-debug.o
  CC      lib/devres.o
  LD      drivers/media/IR/keymaps/built-in.o
  CC      fs/inode.o
  LD      drivers/misc/cb710/built-in.o
  CC      net/core/iovec.o
  LD      drivers/misc/eeprom/built-in.o
  CC      kernel/time/clocksource.o
  LD      drivers/media/IR/built-in.o
  CC      lib/find_last_bit.o
  CC      fs/attr.o
  CC      drivers/base/module.o
  CC      net/netlink/af_netlink.o
  LD      drivers/misc/built-in.o
  CC      drivers/char/n_tty.o
  CC      fs/bad_inode.o
  CC      drivers/input/input-compat.o
  CC      fs/file.o
  LD      drivers/media/common/tuners/built-in.o
  LD      drivers/media/common/built-in.o
  CC      lib/hweight.o
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/perf_event.c:92: warning: 'perf_pmu_rotate_stop' defined but not used
  CC      fs/filesystems.o
  CC      lib/kernel_lock.o
  CC      drivers/input/ff-core.o
/home/caritas/projects/mce/kernel/linux-mce.git/fs/dcache.c: In function 'd_materialise_unique':
/home/caritas/projects/mce/kernel/linux-mce.git/fs/dcache.c:1899: warning: control reaches end of non-void function
  CC      drivers/input/mousedev.o
  CC      net/ipv4/inetpeer.o
  CC      fs/namespace.o
  CC      lib/smp_processor_id.o
  LD      drivers/media/video/davinci/built-in.o
  CC      net/core/datagram.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  LD      drivers/media/video/built-in.o
  CC      kernel/time/timecompare.o
  CC      block/scsi_ioctl.o
  CC      net/core/stream.o
  LD      drivers/media/built-in.o
  CC      lib/bitrev.o
  CC      net/netlink/genetlink.o
  HOSTCC  lib/gen_crc32table
  LD      drivers/i2c/built-in.o
  CC      net/packet/af_packet.o
  CC      block/noop-iosched.o
  LD      drivers/platform/built-in.o
  CC      drivers/net/Space.o
  CC      block/deadline-iosched.o
  CC      block/cfq-iosched.o
  CC      fs/seq_file.o
  LD      crypto/built-in.o
  CC      drivers/char/tty_ioctl.o
  CC      drivers/rtc/rtc-lib.o
  LD      drivers/serial/built-in.o
  LD      drivers/base/built-in.o
  CC      kernel/time/timeconv.o
  CC      drivers/sh/clk.o
  CC      net/core/scm.o
  CC      net/core/gen_stats.o
  CC      lib/syscall.o
  CC      drivers/scsi/scsi.o
  CC      drivers/char/tty_ldisc.o
  CC      kernel/time/clockevents.o
  LD      kernel/irq/built-in.o
  CC      kernel/time/tick-common.o
  CC      lib/nlattr.o
  CC      drivers/sh/intc.o
  LD      net/ethernet/built-in.o
  CC      drivers/sh/clk-cpg.o
  CC      fs/xattr.o
  CC      lib/atomic64.o
  CC      drivers/video/fb_notify.o
  CC      net/sched/sch_generic.o
  CC      lib/argv_split.o
  CC      fs/libfs.o
  CC      net/core/gen_estimator.o
  CC      fs/fs-writeback.o
  CC      drivers/char/tty_buffer.o
  CC      fs/pnode.o
  CC      drivers/net/loopback.o
  CC      fs/drop_caches.o
  CC      fs/splice.o
  CC      lib/bug.o
  CC      fs/sync.o
  CC      net/core/net_namespace.o
  CC      drivers/char/tty_port.o
  CC      net/core/sysctl_net_core.o
  CC      drivers/char/tty_mutex.o
  CC      drivers/char/pty.o
  CC      drivers/scsi/hosts.o
  CC      net/sched/sch_mq.o
  LD      drivers/rtc/built-in.o
  LD      drivers/watchdog/built-in.o
  CC      net/core/dev.o
  CC      lib/cmdline.o
  CC      net/core/ethtool.o
  CC      lib/ctype.o
/home/caritas/projects/mce/kernel/linux-mce.git/block/cfq-iosched.c: In function 'cfq_async_queue_prio':
/home/caritas/projects/mce/kernel/linux-mce.git/block/cfq-iosched.c:2941: warning: control reaches end of non-void function
  CC      net/core/dev_addr_lists.o
  CC      lib/dec_and_lock.o
  CC      net/sunrpc/clnt.o
  CC      fs/utimes.o
  LD      drivers/net/wireless/built-in.o
  CC      net/core/dst.o
  CC      fs/stack.o
  CC      fs/fs_struct.o
  LD      net/wireless/built-in.o
  CC      lib/decompress.o
  CC      net/unix/af_unix.o
  CC      drivers/char/misc.o
  CC      net/core/netevent.o
  CC      drivers/char/vt_ioctl.o
  CC      net/xfrm/xfrm_policy.o
  LD      kernel/time/built-in.o
  CC      lib/dump_stack.o
  CC      net/core/neighbour.o
  CC      drivers/char/vc_screen.o
  CC      lib/extable.o
  CC      fs/statfs.o
  CC      lib/find_next_bit.o
  CC      drivers/video/fbmem.o
  CC      drivers/char/selection.o
  CC      fs/buffer.o
  CC      net/core/rtnetlink.o
  CC      drivers/char/keyboard.o
  CC      fs/bio.o
  CC      net/xfrm/xfrm_state.o
  CC      fs/block_dev.o
  LD      drivers/net/built-in.o
  CC      fs/direct-io.o
  CC      net/ipv4/protocol.o
  CC      net/core/utils.o
  LD      drivers/input/input-core.o
  LD      drivers/input/built-in.o
  CC      lib/flex_array.o
  CC      net/sunrpc/xprt.o
  CC      net/core/link_watch.o
  CC      net/ipv4/ip_input.o
  CC      fs/mpage.o
  CC      lib/idr.o
  CC      net/sysctl_net.o
  CC      drivers/char/consolemap.o
  CC      lib/int_sqrt.o
  CC      fs/ioprio.o
  LD      mm/built-in.o
  CC      fs/debugfs/inode.o
  CC      lib/irq_regs.o
  CC      drivers/video/fbmon.o
  CC      fs/devpts/inode.o
  CONMK   drivers/char/consolemap_deftbl.c
  CC      drivers/char/vt.o
  CC      lib/is_single_threaded.o
  CC      net/core/filter.o
  CC      lib/klist.o
  CC      net/core/flow.o
  CC      net/core/net-sysfs.o
  CC      drivers/video/fbcmap.o
  CC      lib/kobject.o
  SHIPPED drivers/char/defkeymap.c
  CC      drivers/char/sysrq.o
  CC      net/ipv4/ip_fragment.o
  CC      fs/ext2/balloc.o
  CC      lib/kobject_uevent.o
  CC      net/xfrm/xfrm_hash.o
  CC      fs/jbd/transaction.o
  CC      net/ipv4/ip_forward.o
  CC      net/unix/garbage.o
  CC      drivers/char/hw_random/core.o
  CC      net/ipv4/ip_options.o
  CC      fs/ext3/balloc.o
  CC      drivers/scsi/scsi_ioctl.o
  CC      drivers/video/fbsysfs.o
  CC      drivers/scsi/constants.o
  CC      lib/kref.o
  CC      fs/lockd/clntlock.o
  CC      lib/plist.o
  CC      fs/ext2/dir.o
  CC      fs/minix/bitmap.o
  LD      net/netlink/built-in.o
  CC      fs/ext2/file.o
  CC      fs/ext3/bitmap.o
  CC      lib/prio_heap.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  CC      fs/debugfs/file.o
  CC      lib/prio_tree.o
  CC      drivers/char/consolemap_deftbl.o
/home/caritas/projects/mce/kernel/linux-mce.git/net/xfrm/xfrm_policy.c: In function 'xfrm_policy_register_afinfo':
/home/caritas/projects/mce/kernel/linux-mce.git/net/xfrm/xfrm_policy.c:2393: warning: 'xfrm_dst_ops' may be used uninitialized in this function
  CC      net/xfrm/xfrm_input.o
  LD      fs/nfs_common/built-in.o
  LD      drivers/sh/built-in.o
  CC      net/xfrm/xfrm_output.o
  CC      drivers/char/defkeymap.o
  CC      fs/notify/fsnotify.o
  CC      lib/proportions.o
  LD      drivers/char/hw_random/rng-core.o
  LD      net/sched/built-in.o
  CC      fs/nfs/client.o
  LD      drivers/char/hw_random/built-in.o
  CC      net/sunrpc/socklib.o
  CC      lib/radix-tree.o
  CC      drivers/video/modedb.o
/home/caritas/projects/mce/kernel/linux-mce.git/net/packet/af_packet.c: In function 'tpacket_rcv':
/home/caritas/projects/mce/kernel/linux-mce.git/net/packet/af_packet.c:657: warning: 'hdrlen' may be used uninitialized in this function
  CC      fs/ext3/dir.o
  CC      lib/ratelimit.o
  CC      lib/rbtree.o
  CC      fs/ext3/file.o
  CC      fs/ext2/ialloc.o
  CC      fs/partitions/check.o
  CC      lib/reciprocal_div.o
  CC      drivers/scsi/scsicam.o
  CC      lib/rwsem-spinlock.o
  CC      net/unix/sysctl_net_unix.o
  CC      lib/sha1.o
  CC      drivers/video/fbcvt.o
  CC      net/sunrpc/xprtsock.o
  CC      fs/minix/itree_v1.o
  CC      net/xfrm/xfrm_algo.o
  LD      fs/quota/built-in.o
  CC      fs/ramfs/inode.o
  LD      drivers/video/backlight/built-in.o
  CC      fs/notify/notification.o
  CC      fs/romfs/storage.o
  CC      lib/show_mem.o
  CC      fs/romfs/super.o
  CC      fs/proc/nommu.o
  CC      drivers/video/console/dummycon.o
  LD      fs/debugfs/debugfs.o
  CC      net/sunrpc/sched.o
  LD      fs/debugfs/built-in.o
  CC      lib/string.o
  CC      net/ipv4/ip_output.o
  CC      fs/minix/itree_v2.o
  CC      fs/sysfs/inode.o
  CC      fs/eventpoll.o
  CC      fs/ext2/inode.o
  CC      fs/ext3/fsync.o
  CC      lib/vsprintf.o
  CC      fs/anon_inodes.o
  CC      net/xfrm/xfrm_sysctl.o
  LD      drivers/video/display/built-in.o
  CC      net/sunrpc/auth.o
  CC      net/ipv4/ip_sockglue.o
  CC      fs/ext2/ioctl.o
  CC      net/sunrpc/auth_null.o
  CC      drivers/video/logo/logo.o
  CC      drivers/scsi/scsi_error.o
  CC      fs/sysfs/file.o
  CC      fs/notify/group.o
  CC      fs/lockd/clntproc.o
  CC      fs/signalfd.o
  CC      net/ipv4/inet_hashtables.o
  CC      drivers/scsi/scsi_lib.o
  CC      fs/ramfs/file-nommu.o
  GEN     lib/crc32table.h
  CC      fs/ext3/ialloc.o
  CC      fs/sysfs/dir.o
  CC      fs/proc/task_nommu.o
  CC      fs/lockd/host.o
  CC      lib/crc32.o
  CC      fs/timerfd.o
  CC      fs/ext2/namei.o
  CC      fs/ext2/super.o
  LOGO    drivers/video/logo/logo_superh_clut224.c
  CC      fs/ext3/inode.o
  CC      fs/minix/namei.o
  LOGO    drivers/video/logo/logo_linux_mono.c
  LD      drivers/video/omap2/displays/built-in.o
  LOGO    drivers/video/logo/logo_superh_mono.c
  CC      fs/jbd/commit.o
  LOGO    drivers/video/logo/clut_vga16.c
  CC      fs/eventfd.o
  LOGO    drivers/video/logo/logo_blackfin_vga16.c
  CC      fs/ext2/symlink.o
  CC      drivers/video/console/fbcon.o
  LOGO    drivers/video/logo/logo_linux_vga16.c
  LD      drivers/video/omap2/dss/built-in.o
  LOGO    drivers/video/logo/logo_superh_vga16.c
  CC      fs/lockd/svc.o
  CC      fs/partitions/msdos.o
  LOGO    drivers/video/logo/logo_blackfin_clut224.c
  CC      fs/notify/inode_mark.o
  CC      fs/proc/inode.o
  LOGO    drivers/video/logo/logo_dec_clut224.c
  LD      drivers/video/omap2/omapfb/built-in.o
  CC      fs/notify/mark.o
  LOGO    drivers/video/logo/logo_linux_clut224.c
  LD      net/unix/unix.o
  LOGO    drivers/video/logo/logo_m32r_clut224.c
  LD      drivers/video/omap2/built-in.o
  LD      net/unix/built-in.o
  LOGO    drivers/video/logo/logo_mac_clut224.c
  CC      fs/ext3/ioctl.o
  LOGO    drivers/video/logo/logo_parisc_clut224.c
  LOGO    drivers/video/logo/logo_sgi_clut224.c
  LOGO    drivers/video/logo/logo_spe_clut224.c
  CC      fs/notify/vfsmount_mark.o
  LOGO    drivers/video/logo/logo_sun_clut224.c
  CC      fs/nfs/dir.o
  CC      drivers/video/fb_defio.o
  CC      drivers/video/logo/logo_superh_clut224.o
  CC      fs/lockd/svclock.o
  CC      drivers/video/output.o
  CC      drivers/scsi/scsi_lib_dma.o
  CC      fs/ext3/namei.o
  CC      fs/minix/inode.o
  CC      fs/sysfs/symlink.o
  CC      fs/aio.o
  CC      fs/proc/root.o
  LD      drivers/video/logo/built-in.o
  CC      fs/notify/dnotify/dnotify.o
  CC [M]  drivers/video/sysfillrect.o
  CC [M]  drivers/video/syscopyarea.o
  CC      fs/minix/file.o
  CC      fs/sysfs/mount.o
  LD      net/packet/built-in.o
  LD      fs/ramfs/ramfs.o
  CC      fs/sysfs/bin.o
  LD      fs/ramfs/built-in.o
  CC      fs/ext3/super.o
  CC      fs/locks.o
  CC [M]  drivers/video/sysimgblt.o
  CC      fs/minix/dir.o
  LD      lib/built-in.o
  LD      kernel/built-in.o
  LD      fs/romfs/romfs.o
  CC      drivers/scsi/scsi_scan.o
  CC      fs/lockd/svcshare.o
  LD      fs/notify/fanotify/built-in.o
  LD      fs/romfs/built-in.o
  CC      fs/binfmt_script.o
  CC      fs/ext3/symlink.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      fs/notify/inotify/inotify_fsnotify.o
  CC      fs/nfs/file.o
  CC      fs/ext3/hash.o
  CC      fs/notify/inotify/inotify_user.o
  LD      block/built-in.o
  CC      fs/ext3/resize.o
  CC      fs/lockd/svcproc.o
  CC      net/sunrpc/auth_unix.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      net/sunrpc/auth_generic.o
  CC      fs/binfmt_elf_fdpic.o
  CC [M]  drivers/video/fb_sys_fops.o
  CC      fs/proc/base.o
  CC      fs/mbcache.o
  CC      fs/sysfs/group.o
  LD      fs/partitions/built-in.o
  CC      net/ipv4/inet_timewait_sock.o
  CC      net/ipv4/inet_connection_sock.o
  CC      fs/proc/generic.o
  CC      drivers/scsi/scsi_sysctl.o
  CC      net/ipv4/tcp.o
  CC      fs/lockd/svcsubs.o
  CC      drivers/video/console/bitblit.o
  CC      fs/lockd/mon.o
  CC      fs/lockd/xdr.o
  CC      fs/ext3/ext3_jbd.o
  CC      drivers/scsi/scsi_proc.o
  CC [M]  drivers/video/sh_mobile_lcdcfb.o
  CC      fs/proc/array.o
  CC      fs/ext3/xattr.o
  CC      fs/proc/proc_tty.o
  LD      drivers/video/fb.o
  CC      drivers/video/console/fonts.o
  LD      fs/notify/dnotify/built-in.o
  CC      fs/jbd/recovery.o
  CC      net/sunrpc/svc.o
  CC      net/ipv4/tcp_input.o
  CC      drivers/scsi/scsi_trace.o
  CC      drivers/scsi/sd.o
  CC      drivers/scsi/scsi_transport_spi.o
  CC      fs/nfs/getroot.o
  CC [M]  drivers/scsi/scsi_wait_scan.o
  CC      fs/lockd/grace.o
  LD      fs/minix/minix.o
  CC      fs/nfs/inode.o
  LD      fs/sysfs/built-in.o
  LD      fs/minix/built-in.o
  CC      fs/nfs/super.o
  LD      fs/ext2/ext2.o
  AR      lib/lib.a
  CC      net/ipv4/tcp_output.o
  LD      fs/ext2/built-in.o
  CC      fs/ext3/xattr_user.o
  CC      fs/jbd/checkpoint.o
  CC      fs/lockd/xdr4.o
  CC      fs/nfs/nfs2xdr.o
  LD      net/core/built-in.o
  CC      fs/jbd/revoke.o
  CC      net/sunrpc/svcsock.o
  CC      net/sunrpc/svcauth.o
  CC      fs/jbd/journal.o
  CC      net/ipv4/tcp_timer.o
  CC      fs/ext3/xattr_trusted.o
  CC      fs/lockd/svc4proc.o
  CC      drivers/video/console/font_8x16.o
  CC      fs/nfs/direct.o
  CC      net/sunrpc/svcauth_unix.o
  CC      fs/proc/cmdline.o
  CC      net/ipv4/tcp_ipv4.o
  CC      fs/proc/cpuinfo.o
  LD      drivers/hid/hid.o
  CC      net/ipv4/tcp_minisocks.o
  LD      drivers/hid/built-in.o
  CC      fs/proc/devices.o
  CC      fs/nfs/pagelist.o
  CC      net/sunrpc/addr.o
  CC      fs/proc/interrupts.o
  CC      drivers/video/console/softcursor.o
  CC      fs/proc/loadavg.o
  LD      net/xfrm/built-in.o
  CC      fs/proc/meminfo.o
  CC      net/ipv4/tcp_cong.o
  CC      net/sunrpc/rpcb_clnt.o
  LD      drivers/video/console/font.o
  CC      net/sunrpc/timer.o
  CC      fs/nfs/proc.o
  CC      fs/proc/stat.o
  CC      fs/proc/uptime.o
  CC      fs/nfs/read.o
  LD      fs/notify/inotify/built-in.o
  CC      net/ipv4/datagram.o
  LD      fs/notify/built-in.o
  CC      fs/proc/version.o
  CC      fs/nfs/symlink.o
  CC      net/sunrpc/xdr.o
  CC      fs/proc/softirqs.o
  CC      net/ipv4/raw.o
  CC      fs/proc/proc_sysctl.o
  CC      net/ipv4/udp.o
  CC      net/sunrpc/sunrpc_syms.o
  CC      fs/proc/proc_net.o
  CC      fs/proc/kmsg.o
  CC      fs/nfs/unlink.o
  CC      net/ipv4/udplite.o
  CC      net/sunrpc/cache.o
  CC      fs/nfs/write.o
  CC      net/sunrpc/rpc_pipe.o
  CC      net/sunrpc/svc_xprt.o
  CC      net/sunrpc/stats.o
  CC      fs/nfs/namespace.o
  CC      fs/nfs/mount_clnt.o
  CC      fs/nfs/dns_resolve.o
  CC      fs/nfs/cache_lib.o
  CC      net/sunrpc/sysctl.o
  CC      net/ipv4/arp.o
  CC      fs/nfs/nfsroot.o
  CC      fs/nfs/nfs3proc.o
  CC      fs/nfs/nfs3xdr.o
  CC      net/sunrpc/auth_gss/auth_gss.o
  CC      net/sunrpc/auth_gss/gss_generic_token.o
  CC      fs/nfs/sysctl.o
  CC      net/ipv4/icmp.o
  CC      net/ipv4/devinet.o
  CC      net/sunrpc/auth_gss/gss_mech_switch.o
  CC      net/ipv4/af_inet.o
  CC      net/ipv4/igmp.o
  CC      net/ipv4/fib_frontend.o
  CC      net/sunrpc/auth_gss/svcauth_gss.o
  CC      net/sunrpc/auth_gss/gss_krb5_mech.o
  CC      net/ipv4/fib_semantics.o
  CC      net/ipv4/inet_fragment.o
  CC      net/sunrpc/auth_gss/gss_krb5_seal.o
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      net/ipv4/fib_hash.o
  CC      net/sunrpc/auth_gss/gss_krb5_unseal.o
  CC      net/sunrpc/auth_gss/gss_krb5_seqnum.o
  CC      net/ipv4/proc.o
  CC      net/ipv4/xfrm4_mode_beet.o
  LD      fs/jbd/jbd.o
  CC      net/ipv4/xfrm4_mode_transport.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  LD      fs/jbd/built-in.o
  CC      net/sunrpc/auth_gss/gss_krb5_wrap.o
  CC      net/sunrpc/auth_gss/gss_krb5_crypto.o
  CC      net/ipv4/ipconfig.o
  CC      net/sunrpc/auth_gss/gss_krb5_keys.o
  CC      net/ipv4/inet_diag.o
  LD      fs/lockd/lockd.o
  CC      net/ipv4/tcp_diag.o
  CC      net/ipv4/tcp_cubic.o
  CC      net/ipv4/xfrm4_policy.o
  LD      fs/lockd/built-in.o
  CC      net/ipv4/xfrm4_state.o
  LD      fs/proc/proc.o
  CC      net/ipv4/xfrm4_input.o
/home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/svcauth_unix.c: In function 'svcauth_unix_set_client':
/home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/svcauth_unix.c:690: warning: 'sin6' may be used uninitialized in this function
  LD      fs/proc/built-in.o
  CC      net/ipv4/xfrm4_output.o
  LD      drivers/video/console/built-in.o
  LD      drivers/video/built-in.o
  LD      drivers/scsi/scsi_mod.o
  LD      drivers/scsi/sd_mod.o
  LD      drivers/scsi/built-in.o
  LD      fs/ext3/ext3.o
  LD      fs/ext3/built-in.o
  LD      fs/nfs/nfs.o
  LD      fs/nfs/built-in.o
  LD      net/sunrpc/sunrpc.o
  LD      fs/built-in.o
  LD      drivers/char/built-in.o
  LD      drivers/built-in.o
  LD      net/sunrpc/auth_gss/auth_rpcgss.o
  LD      net/sunrpc/auth_gss/rpcsec_gss_krb5.o
  LD      net/sunrpc/auth_gss/built-in.o
  LD      net/sunrpc/built-in.o
  LD      net/ipv4/built-in.o
  LD      net/built-in.o
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

--=-JY4V+1DsyOs8480myzk5--

