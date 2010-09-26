Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0IZAkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:40:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:2209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0IZAkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:40:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,237,1283756400"; 
   d="scan'208";a="661135074"
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Huang Ying <ying.huang@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Russell King <rmk@arm.linux.org.uk>,
        Kyle McMartin <kyle@mcmartin.ca>, davem <davem@davemloft.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <615.1285272720@redhat.com>
References: <1284627425.2754.434.camel@yhuang-dev>
	 <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	 <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
	 <1284377790.2275.212.camel@laptop>
	 <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
	 <1284539320.3764.266.camel@twins>  <615.1285272720@redhat.com>
Content-Type: multipart/mixed; boundary="=-+sfjGoEoL3qOvAitG6mB"
Date: Sun, 26 Sep 2010 08:40:24 +0800
Message-ID: <1285461624.15685.51.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+sfjGoEoL3qOvAitG6mB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2010-09-24 at 04:12 +0800, David Howells wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > Where can I find latest FRV cross compiler workable for Linux kernel?
> 
> Look in here:
> 
> 	ftp://ftp.ges.redhat.com/frv/
> 
> There's a toolchain here:
> 
> 	ftp://ftp.ges.redhat.com/frv/i686-pc-linux-gnulibc2.3-x-frv-linux-gnu.tar.bz2
> 
> plus sources.

Sorry, still have compile error, build log attached.

Best Regards,
Huang Ying

--=-+sfjGoEoL3qOvAitG6mB
Content-Disposition: attachment; filename="log_frv"
Content-Type: text/plain; name="log_frv"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

make -C /home/caritas/projects/mce/kernel/linux-mce.git O=/home/caritas/projects/mce/kernel/build-cross/obj-frv/. 
  HOSTCC  scripts/basic/fixdep
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-frv/Makefile
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig arch/frv/Kconfig
  GEN     /home/caritas/projects/mce/kernel/build-cross/obj-frv/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  Using /home/caritas/projects/mce/kernel/linux-mce.git as source for kernel
  HOSTCC  scripts/kallsyms
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/frv/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/caritas/projects/mce/kernel/linux-mce.git/scripts/checksyscalls.sh
<stdin>:1522:2: warning: #warning syscall recvmmsg not implemented
<stdin>:1526:2: warning: #warning syscall fanotify_init not implemented
<stdin>:1530:2: warning: #warning syscall fanotify_mark not implemented
<stdin>:1534:2: warning: #warning syscall prlimit64 not implemented
  CHK     include/generated/compile.h
  LD      usr/built-in.o
  CC      init/main.o
  CC      init/do_mounts.o
  CC      init/noinitramfs.o
  AS      arch/frv/kernel/head-mmu-fr451.o
  CC      arch/frv/mm/init.o
  AS      arch/frv/kernel/entry.o
  AS      arch/frv/kernel/entry-table.o
  CC      arch/frv/mm/kmap.o
  CC      arch/frv/mb93090-mb00/pci-frv.o
  AS      arch/frv/kernel/break.o
  CC      arch/frv/mb93090-mb00/pci-irq.o
  CC      arch/frv/mm/pgalloc.o
  CC      arch/frv/mb93090-mb00/pci-vdk.o
  CC      arch/frv/mb93090-mb00/pci-iomap.o
  CC      arch/frv/mm/highmem.o
  AS      arch/frv/kernel/switch_to.o
  CC      arch/frv/mb93090-mb00/pci-dma.o
  CC      arch/frv/mm/fault.o
  AS      arch/frv/kernel/kernel_thread.o
  AS      arch/frv/kernel/kernel_execve.o
  CC      arch/frv/mm/extable.o
  CC      arch/frv/kernel/process.o
  AS      arch/frv/mm/tlb-flush.o
  CC      arch/frv/mm/cache-page.o
  CC      arch/frv/kernel/traps.o
  AS      arch/frv/mm/tlb-miss.o
  CC      arch/frv/kernel/ptrace.o
  CC      arch/frv/kernel/signal.o
  CC      arch/frv/mm/mmu-context.o
  CC      arch/frv/kernel/dma.o
  CC      arch/frv/kernel/sys_frv.o
  CC      kernel/sched.o
  CC      arch/frv/kernel/time.o
  CC      kernel/fork.o
  CC      arch/frv/mm/dma-alloc.o
  CC      arch/frv/kernel/setup.o
  CC      arch/frv/kernel/frv_ksyms.o
  CC      kernel/exec_domain.o
  CC      mm/bootmem.o
  CC      arch/frv/kernel/debug-stub.o
  CC      arch/frv/mm/elf-fdpic.o
  CC      mm/filemap.o
  CC      arch/frv/kernel/irq.o
  AS      arch/frv/kernel/sleep.o
  CC      kernel/panic.o
  CC      arch/frv/kernel/uaccess.o
  CC      kernel/printk.o
  CC      mm/mempool.o
  CC      arch/frv/kernel/irq-mb93091.o
  CC      arch/frv/kernel/sysctl.o
  CC      mm/oom_kill.o
  CC      kernel/cpu.o
  CC      arch/frv/kernel/futex.o
  AS      arch/frv/kernel/head.o
  CC      kernel/exit.o
  CC      ipc/util.o
  CC      arch/frv/kernel/init_task.o
  CC      ipc/msgutil.o
  CC      mm/fadvise.o
  CC      security/commoncap.o
  CC      fs/open.o
  CC      crypto/api.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-flush.S: Assembler messages:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-flush.S:51: Error: operand out of range (4294967295 not between -32768 and 32767) `setlos #0xffffffff,gr4'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-flush.S:95: Error: operand out of range (4294967295 not between -32768 and 32767) `setlos #0xffffffff,gr4'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-flush.S:135: Error: operand out of range (4294967295 not between -32768 and 32767) `setlos #0xffffffff,gr4'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-flush.S:163: Error: operand out of range (4294967295 not between -32768 and 32767) `setlos #0xffffffff,gr4'
make[3]: *** [arch/frv/mm/tlb-flush.o] Error 1
make[3]: *** Waiting for unfinished jobs....
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S: Assembler messages:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:178: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos.p 0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:193: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos #0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:307: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos.p 0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:322: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos #0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:433: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos.p 0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:443: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos #0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:553: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos.p 0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/tlb-miss.S:563: Error: operand out of range (4294963200 not between -32768 and 32767) `setlos #0xfffff000,gr31'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/break.S: Assembler messages:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/break.S:219: Error: operand out of range (4294959104 not between -32768 and 32767) `setlos #0xffffe000,gr3'
make[3]: *** [arch/frv/mm/tlb-miss.o] Error 1
make[3]: *** [arch/frv/kernel/break.o] Error 1
make[3]: *** Waiting for unfinished jobs....
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/head.S: Assembler messages:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/head.S:52: Error: operand out of range (0xffffffff31ff not between 0 and 0xffff) `sethi.p %hi(~(0x80000000|0x40000000|0x08000000|0x0...'
  CC      ipc/shm.o
  CC      crypto/cipher.o
  LDS     arch/frv/kernel/vmlinux.lds
  CC      mm/maccess.o
  CC      ipc/sem.o
make[3]: *** [arch/frv/kernel/head.o] Error 1
  CC      fs/read_write.o
  CC      ipc/msg.o
  CC      fs/file_table.o
  CC      security/min_addr.o
  CC      mm/page_alloc.o
  CC      mm/page-writeback.o
  CC      mm/readahead.o
  CC      block/elevator.o
  UPD     include/generated/compile.h
  CC      block/blk-core.o
  CC      block/blk-tag.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/init.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/blk-sysfs.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/fork.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-tag.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'

/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/pgalloc.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/cache-page.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/sched.c:34:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/process.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mempool.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mm/highmem.c:11:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/cipher.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/blk-barrier.o
  CC      kernel/itimer.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/readahead.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/fadvise.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  TIMEC   kernel/timeconst.h
  CC      mm/swap.o
  CC      crypto/compress.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/filemap.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/api.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/shmem_fs.h:5,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/shm.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/page-writeback.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/truncate.o
  CC      mm/vmscan.o
  CC      fs/super.o
  LD      sound/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/security/commoncap.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/elevator.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-core.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/algapi.o
  CC      block/blk-settings.o
  CC      block/blk-ioc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/page_alloc.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-sysfs.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      firmware/built-in.o
  CC      kernel/softirq.o
  CC      block/blk-map.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-barrier.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/oom_kill.c:32:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/vmscan.c:19:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mb93090-mb00/pci-frv.c: In function 'pcibios_assign_resources':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mb93090-mb00/pci-frv.c:176:24: warning: ignoring return value of 'pci_assign_resource', declared with attribute warn_unused_result
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mb93090-mb00/pci-frv.c:184:24: warning: ignoring return value of 'pci_assign_resource', declared with attribute warn_unused_result
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/open.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/bcd.o
  CC      net/socket.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/mb93090-mb00/pci-dma.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/blk-exec.o
  CC      block/blk-merge.o
  CC      fs/char_dev.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/truncate.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/read_write.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/swap.c:21:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/resource.o
  CC      crypto/scatterwalk.o
make[2]: *** [arch/frv/mm] Error 2
make[2]: *** Waiting for unfinished jobs....
  CC      crypto/proc.o
  CC      kernel/sysctl.o
  CC      fs/stat.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/exit.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/ablkcipher.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/do_mounts.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/blkcipher.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      init/version.o
  CC      mm/shmem.o
  LD      drivers/auxdisplay/built-in.o
  LD      net/802/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-ioc.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      ipc/ipcns_notifier.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/compress.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      ipc/syscall.o
  CC      kernel/sysctl_binary.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-map.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/ahash.o
  CC      mm/prio_tree.o
  CC      kernel/capability.o
  CC      net/core/sock.o
  CC      block/blk-softirq.o
  CC      mm/util.o
  CC      drivers/base/core.o
  CC      lib/div64.o
  LD      arch/frv/mb93090-mb00/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-settings.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/sort.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/super.c:26:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':  CC      crypto/shash.o

/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/kernel/setup.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/exec.o
  CC      ipc/ipc_sysctl.o
  CC      ipc/mqueue.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/proc.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/blk-timeout.o
  CC      block/blk-iopoll.o
  CC      block/blk-lib.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/algapi.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/scatterwalk.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/ioctl.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/init/main.c:50:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/mmzone.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-exec.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-merge.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/vmstat.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/stat.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/ptrace.o
  CC      crypto/algboss.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/blkcipher.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      ipc/mq_sysctl.o
  CC      crypto/testmgr.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/shmem.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/genhd.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-softirq.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/scsi_ioctl.o
  CC      block/bsg.o
  CC      mm/backing-dev.o
  CC      mm/page_isolation.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/sysctl.c:50:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-lib.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/crypto_wq.o
  CC      lib/parser.o
  CC      fs/pipe.o
  CC      kernel/timer.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ahash.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/base/sys.o
  CC      block/noop-iosched.o
  CC      block/deadline-iosched.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ablkcipher.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      block/cfq-iosched.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/mm_init.o
  CC      kernel/user.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/ptrace.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/shash.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/testmgr.c:24:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/signal.o
  CC      mm/mmu_context.o
  CC      mm/fremap.o
  CC      lib/halfmd4.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/exec.c:34:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/ipc/mqueue.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/socket.c:80:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/base/bus.o
  CC      fs/namei.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-iopoll.c:8:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/ioctl.c:2:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/backing-dev.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/blk-timeout.c:6:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/genhd.c:10:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/scsi_ioctl.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/bsg.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/fcntl.o
  CC      mm/highmem.o
  CC      mm/madvise.o
  CC      kernel/sys.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/pipe.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/aead.o
  CC      mm/memory.o
  CC      net/core/request_sock.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/cfq-iosched.c:11:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/ioctl.o
  CC      fs/readdir.o
  CC      lib/debug_locks.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/noop-iosched.c:4:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/chainiv.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/block/deadline-iosched.c:8:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/algboss.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      security/built-in.o
  CC      mm/mincore.o
  CC      lib/random32.o
  CC      crypto/eseqiv.o
  CC      fs/select.o
  CC      mm/mlock.o
  CC      fs/fifo.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/core/sock.c:112:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/fremap.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/namei.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/dcache.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/highmem.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
make[2]: *** [arch/frv/kernel] Error 2
  CC      lib/bust_spinlocks.o
  CC      fs/inode.o
  CC      kernel/kmod.o
  CC      crypto/pcompress.o
  CC      drivers/base/dd.o
  CC      lib/hexdump.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/memory.c:46:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/mmap.o
  CC      kernel/workqueue.o
  CC      kernel/pid.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mincore.c:10:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/md5.o
  CC      kernel/rcupdate.o
  CC      mm/mprotect.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/madvise.c:9:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/mremap.o
  CC      kernel/extable.o
  CC      crypto/cbc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mlock.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/crypto/scatterwalk.h:22,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/eseqiv.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      crypto/des_generic.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/aead.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/buffer_head.h:13,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/ioctl.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mmap.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      init/mounts.o
  LD      init/built-in.o
  CC      kernel/params.o
  CC      lib/kasprintf.o
  CC      fs/attr.o
  CC      kernel/posix-timers.o
  CC      mm/msync.o
  CC      fs/bad_inode.o
  CC      lib/bitmap.o
  CC      kernel/kthread.o
  CC      crypto/aes_generic.o
  CC      drivers/base/driver.o
  CC      kernel/wait.o
  CC      mm/rmap.o
  CC      crypto/rng.o
  CC      mm/vmalloc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/inode.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/core/skbuff.o
  CC      kernel/kfifo.o
  CC      lib/scatterlist.o
  CC      crypto/krng.o
  CC      drivers/base/class.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/pcompress.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/pagewalk.o
  LD      drivers/block/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/workqueue.c:31:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/file.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mprotect.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ksm.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/mremap.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/string_helpers.o
  CC      mm/init-mm.o
  CC      lib/gcd.o
  CC      fs/filesystems.o
  LD      drivers/cdrom/built-in.o
  CC      mm/bounce.o
  CC      fs/namespace.o
  CC      mm/page_io.o
  CC      crypto/ansi_cprng.o
  CC      drivers/char/mem.o
  CC      kernel/sys_ni.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/pagewalk.c:2:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/rmap.c:47:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/lcm.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/lib/scatterlist.c:12:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/posix-cpu-timers.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/vmalloc.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/seq_file.o
  CC      drivers/base/platform.o
  CC      drivers/base/cpu.o
  LD      drivers/clocksource/built-in.o
  CC      kernel/mutex.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/bounce.c:10:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/swap_state.o
  CC      kernel/hrtimer.o
  CC      mm/swapfile.o
  CC      net/core/iovec.o
  CC      mm/thrash.o
  CC      net/ethernet/eth.o
  LD      drivers/crypto/built-in.o
  CC      lib/list_sort.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/internal.h:19,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/crypto/ansi_cprng.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/rwsem.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/core/kmap_skb.h:1,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/core/skbuff.c:71:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/base/firmware.o
  LD      drivers/firmware/built-in.o
  CC      kernel/nsproxy.o
  CC      lib/uuid.o
  CC      lib/iomap_copy.o
  CC      fs/xattr.o
  LD      drivers/gpio/built-in.o
  CC      drivers/base/init.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/page_io.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/devres.o
  CC      fs/libfs.o
  CC      mm/dmapool.o
  CC      mm/slub.o
  CC      mm/percpu_up.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/swap_state.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      mm/quicklist.o
  LD      drivers/gpu/drm/i2c/built-in.o
  LD      crypto/crypto.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/drivers/char/mem.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      crypto/crypto_algapi.o
  CC      lib/find_last_bit.o
  CC      fs/fs-writeback.o
  LD      crypto/crypto_blkcipher.o
  LD      drivers/gpu/drm/built-in.o
  CC      kernel/srcu.o
  LD      crypto/crypto_hash.o
  CC      lib/hweight.o
  LD      crypto/cryptomgr.o
  CC      kernel/semaphore.o
  CC      drivers/gpu/vga/vgaarb.o
  CC      kernel/notifier.o
  CC      kernel/ksysfs.o
  CC      lib/bitrev.o
  CC      drivers/base/map.o
  CC      kernel/pm_qos_params.o
  CC      drivers/hwmon/hwmon.o
  CC      drivers/base/devres.o
  CC      drivers/base/attribute_container.o
  CC      drivers/base/transport_class.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/swapfile.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/char/random.o
  LD      ipc/built-in.o
  HOSTCC  lib/gen_crc32table
  CC      lib/syscall.o
  LD      drivers/i2c/algos/built-in.o
  CC      fs/pnode.o
  CC      drivers/base/dma-mapping.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/mm/slub.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/drop_caches.o
  LD      drivers/base/power/built-in.o
  CC      kernel/sched_clock.o
  CC      lib/nlattr.o
  LD      drivers/i2c/busses/built-in.o
  CC      fs/splice.o
  CC      fs/sync.o
  CC      kernel/cred.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/libfs.c:7:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/route.o
  CC      lib/argv_split.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/fs-writeback.c:26:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/async.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/char/tty_io.o
  LD      drivers/i2c/muxes/built-in.o
  CC      kernel/range.o
  CC      kernel/groups.o
  CC      lib/cmdline.o
  LD      drivers/i2c/built-in.o
  CC      net/core/datagram.o
  CC      fs/utimes.o
  CC      lib/ctype.o
  CC      net/netlink/af_netlink.o
  LD      net/ethernet/built-in.o
  LD      drivers/idle/built-in.o
  CC      net/netlink/genetlink.o
  LD      drivers/ieee1394/built-in.o
  LD      drivers/ieee802154/built-in.o
  CC      fs/stack.o
  CC      net/packet/af_packet.o
  CC      net/sched/sch_generic.o
  CC      kernel/irq/handle.o
  CC      lib/dec_and_lock.o
  LD      drivers/lguest/built-in.o
  LD      drivers/hwmon/built-in.o
  LD      drivers/macintosh/built-in.o
  CC      kernel/time/timekeeping.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/splice.c:22:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':  CC      kernel/futex.o

/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/fs_struct.o
  LD      drivers/mfd/built-in.o
  CC      lib/decompress.o
  CC      lib/dump_stack.o
  CC      lib/extable.o
  CC      drivers/net/mii.o
  CC      lib/find_next_bit.o
  CC      kernel/irq/manage.o
  CC      drivers/pci/access.o
  LD      drivers/misc/cb710/built-in.o
  LD      block/built-in.o
  CC      kernel/rtmutex.o
  CC      kernel/irq/spurious.o
  LD      drivers/media/IR/keymaps/built-in.o
  LD      drivers/platform/built-in.o
  CC      lib/flex_array.o
  CC      lib/idr.o
  CC      fs/statfs.o
  CC      lib/int_sqrt.o
  CC      net/ipv4/inetpeer.o
  CC      lib/ioremap.o
  LD      drivers/media/IR/built-in.o
  LD      drivers/misc/eeprom/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/sync.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/irq_regs.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/core/datagram.c:49:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/char/n_tty.o
  CC      lib/is_single_threaded.o
  CC      drivers/serial/serial_core.o
  LD      drivers/misc/built-in.o
  CC      kernel/up.o
  CC      lib/klist.o
  CC      lib/kobject.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/kernel/futex.c:55:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/async.c: In function 'async_run_entry_fn':
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/async.c:122:10: warning: 'calltime.tv64' may be used uninitialized in this function
  CC      fs/buffer.o
  CC      drivers/net/ne2k-pci.o
  CC      fs/bio.o
  LD      drivers/media/common/tuners/built-in.o
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/async.c: In function 'async_synchronize_cookie_domain':
/home/caritas/projects/mce/kernel/linux-mce.git/kernel/async.c:270:10: warning: 'starttime.tv64' may be used uninitialized in this function
  CC      lib/kref.o
  LD      drivers/base/built-in.o
  CC      drivers/char/tty_ioctl.o
  LD      drivers/media/common/built-in.o
  CC      kernel/uid16.o
  CC      drivers/usb/host/pci-quirks.o
  LD      crypto/built-in.o
  CC      lib/plist.o
  CC      drivers/video/fb_notify.o
  CC      lib/prio_heap.o
  CC      kernel/irq/resend.o
  CC      kernel/kallsyms.o
  LD      drivers/video/backlight/built-in.o
  CC      fs/block_dev.o
  CC      drivers/net/8390.o
  CC      kernel/irq/chip.o
  CC      lib/prio_tree.o
  CC      lib/proportions.o
  CC      kernel/rcutree.o
  LD      drivers/video/display/built-in.o
  LD      drivers/media/video/davinci/built-in.o
  CC      lib/radix-tree.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/elfcore.o
  CC      lib/ratelimit.o
  LD      drivers/media/video/built-in.o
  CC      fs/direct-io.o
  CC      net/ipv4/protocol.o
  CC      fs/mpage.o
  CC      net/sunrpc/clnt.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/bio.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/buffer.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/perf_event.o
  CC      net/sunrpc/xprt.o
  CC      fs/ioprio.o
  LD      drivers/media/built-in.o
  CC      kernel/irq/devres.o
  CC      lib/rbtree.o
  LD      drivers/video/omap2/displays/built-in.o
  CC      lib/reciprocal_div.o
  CC      lib/rwsem-spinlock.o
  CC      drivers/serial/8250.o
  CC      net/sunrpc/socklib.o
  LD      drivers/video/omap2/dss/built-in.o
  CC      drivers/net/Space.o
  CC      lib/sha1.o
  CC      kernel/irq/proc.o
  CC      kernel/time.o
  CC      net/core/stream.o
  CC      drivers/pci/bus.o
  CC      lib/show_mem.o
  CC      lib/string.o
  CC      fs/devpts/inode.o
  LD      drivers/video/omap2/omapfb/built-in.o
  CC      drivers/char/tty_ldisc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/direct-io.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      lib/vsprintf.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/bio.h:23,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/mpage.c:20:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/block_dev.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      drivers/video/omap2/built-in.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/core/scm.o
  CC      drivers/pci/probe.o
  CC      net/core/gen_stats.o
  CC      drivers/serial/8250_pci.o
  CC      net/core/gen_estimator.o
  LD      drivers/video/built-in.o
  CC      fs/lockd/clntlock.o
  CC      net/ipv4/ip_input.o
  GEN     lib/crc32table.h
  CC      net/sched/sch_mq.o
  CC      kernel/time/ntp.o
  CC      drivers/net/loopback.o
  CC      lib/crc32.o
  CC      net/core/net_namespace.o
  CC      net/ipv4/ip_fragment.o
  LD      drivers/net/wireless/built-in.o
  CC      drivers/char/tty_buffer.o
  CC      net/ipv4/ip_forward.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/ioprio.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/time/clocksource.o
  CC      drivers/serial/8250_early.o
  CC      net/unix/af_unix.o
  LD      drivers/gpu/vga/built-in.o
  CC      fs/nfs/client.o
  LD      drivers/gpu/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/lockd/clntlock.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/unix/garbage.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/char/tty_port.o
  CC      fs/nfs/dir.o
  CC      drivers/pci/remove.o
  CC      fs/nfs/file.o
  CC      fs/nfs/getroot.o
  CC      kernel/time/jiffies.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/socklib.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/nfs/inode.o
  CC      fs/nfs/super.o
  LD      kernel/irq/built-in.o
  CC      fs/nfs/nfs2xdr.o
  CC      fs/nfs/direct.o
  CC      drivers/pci/pci.o
  LD      fs/nfs_common/built-in.o
  CC      fs/lockd/clntproc.o
  LD      fs/devpts/devpts.o
  LD      fs/devpts/built-in.o
  CC      net/core/sysctl_net_core.o
  CC      fs/partitions/check.o
  CC      kernel/time/timer_list.o
  LD      drivers/usb/host/built-in.o
  CC      fs/notify/fsnotify.o
  LD      drivers/usb/built-in.o
  CC      net/core/dev.o
  CC      drivers/pci/pci-driver.o
  CC      drivers/pci/search.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/nfs2xdr.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      fs/quota/built-in.o
  LD      lib/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/file.c:24:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      net/sched/built-in.o
  CC      net/core/ethtool.o
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/lockd/host.o
  CC      kernel/time/timecompare.o
  CC      net/core/dev_addr_lists.o
  CC      fs/ramfs/inode.o
  CC      drivers/pci/pci-sysfs.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/lockd/clntproc.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/ramfs/file-mmu.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/dir.c:29:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/sysfs/inode.o
  LD      net/wireless/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/getroot.c:24:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      kernel/time/timeconv.o
  CC      fs/eventpoll.o
  CC      fs/sysfs/file.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/direct.c:45:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/inode.c:29:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/anon_inodes.o
  CC      net/xfrm/xfrm_policy.o
  CC      net/core/dst.o
  CC      drivers/char/tty_mutex.o
  CC      fs/nfs/pagelist.o
  CC      fs/lockd/svc.o
  CC      fs/proc/mmu.o
  CC      net/ipv4/ip_options.o
  CC      net/core/netevent.o
  CC      net/sunrpc/xprtsock.o
  CC      fs/nfs/proc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/ramfs/inode.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/sysctl_net.o
  CC      net/sunrpc/sched.o
  CC      net/core/neighbour.o
  CC      drivers/char/pty.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/client.c:28:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/core/rtnetlink.o
  LD      drivers/net/built-in.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/sysfs/inode.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/ip_output.o
  LD      net/netlink/built-in.o
  CC      net/ipv4/ip_sockglue.o
  CC      net/core/utils.o
  CC      net/xfrm/xfrm_state.o
  CC      net/xfrm/xfrm_hash.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blkdev.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/blktrace_api.h:6,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/partitions/check.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/partitions/msdos.o
  CC      net/xfrm/xfrm_input.o
  CC      net/ipv4/inet_hashtables.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/super.c:38:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/char/misc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/proc/mmu.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/mempolicy.h:70,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/drivers/pci/pci-driver.c:15:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/xprtsock.c:25:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      net/packet/built-in.o
  CC      fs/signalfd.o
  CC      fs/proc/task_mmu.o
  CC      drivers/char/hw_random/core.o
  LD      fs/ramfs/ramfs.o
  CC      net/ipv4/inet_timewait_sock.o
  CC      net/sunrpc/auth.o
  LD      fs/ramfs/built-in.o
  CC      net/core/link_watch.o
  CC      fs/timerfd.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/ipv4/ip_output.c:53:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/sysfs/dir.o
  CC      drivers/pci/rom.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/proc.c:37:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      kernel/time/built-in.o
  LD      mm/built-in.o
  CC      fs/notify/notification.o
  CC      net/unix/sysctl_net_unix.o
  CC      net/xfrm/xfrm_output.o
  CC      fs/notify/group.o
  CC      net/ipv4/inet_connection_sock.o
  CC      drivers/pci/setup-res.o
  CC      drivers/pci/irq.o
  CC      fs/notify/inode_mark.o
  CC      fs/lockd/svclock.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/proc/task_mmu.c:5:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/partitions/check.h:1,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/partitions/msdos.c:23:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      drivers/pci/vpd.o
  CC      fs/eventfd.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/core/dev.c:108:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/aio.o
  CC      net/core/filter.o
  CC      fs/proc/inode.o
  CC      drivers/pci/proc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_page.h:14,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/pagelist.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/locks.o
  CC      fs/lockd/svcshare.o
  CC      drivers/pci/slot.o
  CC      net/ipv4/tcp.o
  CC      net/xfrm/xfrm_algo.o
  LD      drivers/char/hw_random/rng-core.o
  CC      net/core/flow.o
  CC      net/xfrm/xfrm_sysctl.o
  LD      drivers/char/hw_random/built-in.o
  CC      drivers/pci/quirks.o
  CC      fs/lockd/svcproc.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/aio.c:32:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/sysfs/symlink.o
  CC      fs/notify/mark.o
  CC      net/ipv4/tcp_input.o
  CC      fs/binfmt_script.o
  CC      fs/binfmt_elf_fdpic.o
  CC      fs/notify/vfsmount_mark.o
  CC      net/core/net-sysfs.o
  CC      fs/sysfs/mount.o
  CC      fs/nfs/read.o
  CC      net/ipv4/tcp_output.o
  CC      fs/proc/root.o
  CC      fs/nfs/symlink.o
  CC      fs/lockd/svcsubs.o
  CC      net/sunrpc/auth_null.o
  CC      fs/lockd/mon.o
  CC      fs/nfs/unlink.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/ipv4/tcp.c:262:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/proc/base.o
  CC      net/ipv4/tcp_timer.o
  CC      net/ipv4/tcp_ipv4.o
  CC      net/ipv4/tcp_minisocks.o
  LD      drivers/char/built-in.o
  CC      net/sunrpc/auth_unix.o
  CC      net/ipv4/tcp_cong.o
  CC      fs/nfs/write.o
  CC      fs/proc/generic.o
  CC      fs/proc/array.o
  CC      net/sunrpc/auth_generic.o
  CC      fs/proc/proc_tty.o
  CC      fs/nfs/namespace.o
  LD      drivers/serial/built-in.o
  LD      fs/partitions/built-in.o
  CC      fs/sysfs/bin.o
  LD      net/unix/unix.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/sysfs/mount.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/sysfs/group.o
  CC      fs/notify/dnotify/dnotify.o
  LD      net/unix/built-in.o
  LD      fs/notify/fanotify/built-in.o
  CC      net/sunrpc/svc.o
  CC      fs/notify/inotify/inotify_fsnotify.o
  CC      fs/proc/cmdline.o
  CC      fs/proc/cpuinfo.o
  CC      fs/notify/inotify/inotify_user.o
  CC      net/ipv4/datagram.o
  AR      lib/lib.a
  CC      net/ipv4/raw.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/binfmt_elf_fdpic.c:27:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/proc/devices.o
  CC      fs/proc/interrupts.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/read.c:17:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/lockd/xdr.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/write.c:12:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/proc/array.c:69:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/udp.o
  CC      fs/lockd/grace.o
  CC      fs/nfs/mount_clnt.o
  CC      fs/proc/loadavg.o
  CC      net/ipv4/udplite.o
  CC      net/ipv4/arp.o
  CC      net/ipv4/icmp.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/symlink.c:18:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/devinet.o
  CC      fs/proc/meminfo.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/namespace.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/proc/stat.o
  CC      fs/nfs/dns_resolve.o
  CC      fs/nfs/cache_lib.o
  CC      net/ipv4/af_inet.o
  CC      net/sunrpc/svcsock.o
  CC      fs/proc/uptime.o
  CC      net/ipv4/igmp.o
  CC      net/sunrpc/svcauth.o
  LD      fs/notify/dnotify/built-in.o
  CC      net/sunrpc/svcauth_unix.o
  CC      net/ipv4/fib_frontend.o
  CC      fs/proc/version.o
  CC      fs/nfs/nfsroot.o
  CC      fs/nfs/sysctl.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/unlink.c:13:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      fs/proc/softirqs.o
  CC      fs/proc/proc_sysctl.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/ipv4/udp.c:84:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      fs/sysfs/built-in.o
  CC      fs/proc/proc_net.o
  CC      net/sunrpc/addr.o
  CC      net/sunrpc/rpcb_clnt.o
  CC      fs/proc/kmsg.o
  CC      net/sunrpc/timer.o
  CC      net/ipv4/fib_semantics.o
  CC      net/ipv4/inet_fragment.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/mount_clnt.c:16:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/sysctl_net_ipv4.o
  CC      fs/proc/page.o
  CC      net/sunrpc/xdr.o
  CC      net/ipv4/fib_hash.o
  CC      net/ipv4/proc.o
  CC      net/sunrpc/sunrpc_syms.o
  CC      net/sunrpc/cache.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/sysctl.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/xfrm4_mode_beet.o
  CC      net/sunrpc/rpc_pipe.o
  CC      net/ipv4/inet_lro.o
  CC      net/ipv4/xfrm4_mode_transport.o
  CC      net/sunrpc/svc_xprt.o
  CC      net/sunrpc/stats.o
  LD      drivers/pci/built-in.o
  CC      net/sunrpc/sysctl.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/ksm.h:12,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/proc/page.c:5:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      drivers/built-in.o
  CC      net/ipv4/xfrm4_mode_tunnel.o
  CC      net/ipv4/ipconfig.o
  CC      net/ipv4/inet_diag.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/xdr.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/ipv4/tcp_diag.o
  CC      net/ipv4/tcp_cubic.o
  CC      net/ipv4/xfrm4_policy.o
  CC      net/ipv4/xfrm4_state.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/cache.c:30:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  CC      net/sunrpc/auth_gss/auth_gss.o
  CC      net/ipv4/xfrm4_input.o
  CC      net/sunrpc/auth_gss/gss_generic_token.o
  CC      net/ipv4/xfrm4_output.o
  CC      net/sunrpc/auth_gss/gss_mech_switch.o
  LD      fs/lockd/lockd.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/rpc_pipe.c:14:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      fs/lockd/built-in.o
  CC      net/sunrpc/auth_gss/svcauth_gss.o
  CC      net/sunrpc/auth_gss/gss_krb5_mech.o
  CC      net/sunrpc/auth_gss/gss_krb5_seal.o
  CC      net/sunrpc/auth_gss/gss_krb5_unseal.o
  CC      net/sunrpc/auth_gss/gss_krb5_seqnum.o
  CC      net/sunrpc/auth_gss/gss_krb5_wrap.o
  CC      net/sunrpc/auth_gss/gss_krb5_crypto.o
  LD      fs/notify/inotify/built-in.o
  LD      fs/notify/built-in.o
  CC      net/sunrpc/auth_gss/gss_krb5_keys.o
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/fs/nfs/nfsroot.c:79:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/nfs_fs.h:41,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/ipv4/ipconfig.c:55:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/auth_gss/gss_krb5_wrap.c:35:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/auth_gss/gss_krb5_crypto.c:42:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/auth_gss/auth_gss.c:44:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
In file included from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/highmem.h:44:0,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/include/linux/pagemap.h:10,
                 from /home/caritas/projects/mce/kernel/linux-mce.git/net/sunrpc/auth_gss/svcauth_gss.c:43:
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kmap_atomic':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:134:2: warning: case value '72' not in enumerated type 'enum km_type'
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h: In function 'kunmap_atomic_notypecheck':
/home/caritas/projects/mce/kernel/linux-mce.git/arch/frv/include/asm/highmem.h:168:2: warning: case value '72' not in enumerated type 'enum km_type'
  LD      fs/nfs/nfs.o
  LD      fs/nfs/built-in.o
  LD      fs/proc/proc.o
  LD      fs/proc/built-in.o
  LD      fs/built-in.o
  LD      net/sunrpc/sunrpc.o
  LD      net/xfrm/built-in.o
  LD      kernel/built-in.o
frv-linux-ld: Warning: size of symbol `sys_syslog' changed from 16 in kernel/printk.o to 8 in kernel/sys_ni.o
frv-linux-ld: Warning: size of symbol `sys_set_robust_list' changed from 8 in kernel/sys_ni.o to 48 in kernel/futex.o
frv-linux-ld: Warning: size of symbol `sys_get_robust_list' changed from 8 in kernel/sys_ni.o to 296 in kernel/futex.o
frv-linux-ld: Warning: size of symbol `sys_futex' changed from 8 in kernel/sys_ni.o to 440 in kernel/futex.o
frv-linux-ld: Warning: size of symbol `sys_chown16' changed from 8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_lchown16' changed from 8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_fchown16' changed from 8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setregid16' changed from 8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setgid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setreuid16' changed from 8 in kernel/sys_ni.o to 56 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setuid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setresuid16' changed from 8 in kernel/sys_ni.o to 124 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getresuid16' changed from 8 in kernel/sys_ni.o to 284 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setresgid16' changed from 8 in kernel/sys_ni.o to 124 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getresgid16' changed from 8 in kernel/sys_ni.o to 284 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setfsuid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setfsgid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getgroups16' changed from 8 in kernel/sys_ni.o to 252 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_setgroups16' changed from 8 in kernel/sys_ni.o to 440 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getuid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_geteuid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getgid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `sys_getegid16' changed from 8 in kernel/sys_ni.o to 40 in kernel/uid16.o
frv-linux-ld: Warning: size of symbol `early_irq_init' changed from 8 in kernel/softirq.o to 100 in kernel/irq/built-in.o
frv-linux-ld: Warning: size of symbol `sys_perf_event_open' changed from 8 in kernel/sys_ni.o to 1548 in kernel/perf_event.o
  LD      net/sunrpc/auth_gss/auth_rpcgss.o
  LD      net/sunrpc/auth_gss/rpcsec_gss_krb5.o
  LD      net/sunrpc/auth_gss/built-in.o
  LD      net/sunrpc/built-in.o
  LD      net/core/built-in.o
  LD      net/ipv4/built-in.o
  LD      net/built-in.o
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

--=-+sfjGoEoL3qOvAitG6mB--

