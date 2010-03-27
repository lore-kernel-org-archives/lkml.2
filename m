Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0C0OKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:10:32 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:46998 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab0C0OKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:10:30 -0400
From: Fabio Giovagnini <fabio.giovagnini@aurion-tech.com>
Organization: Auiron s.r.l.
To: Andrew Stubbs <ams@codesourcery.com>
Subject: Re: Sourcery G++ 4.4-136 Release
Date: Sat, 27 Mar 2010 15:07:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
References: <201003221942.o2MJgBRf028294@spugna.yepa.com> <201003260659.57890.fabio.giovagnini@aurion-tech.com> <4BAC84F1.2070106@codesourcery.com>
In-Reply-To: <4BAC84F1.2070106@codesourcery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003271507.12509.fabio.giovagnini@aurion-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More results:
when I force elf32-shbig-fdpic in /arch/sh/Makefile I get linker warning and an 
error; while if I leave elf32-shbib-linux I have only linker warning
sh-uclinux-ld: Warning: size of symbol `read_persistent_clock' changed from 24 
in arch/sh/kernel/built-in.o to 16 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `hw_perf_enable' changed from 32 in 
arch/sh/kernel/built-in.o to 10 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `hw_perf_event_setup' changed from 32 
in arch/sh/kernel/built-in.o to 10 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `arch_probe_nr_irqs' changed from 28 in 
arch/sh/kernel/built-in.o to 12 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `hw_perf_event_init' changed from 544 
in arch/sh/kernel/built-in.o to 12 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `perf_callchain' changed from 140 in 
arch/sh/kernel/built-in.o to 12 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `arch_dup_task_struct' changed from 120 
in arch/sh/kernel/built-in.o to 28 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `hw_perf_disable' changed from 32 in 
arch/sh/kernel/built-in.o to 10 in kernel/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mremap' changed from 12 in 
kernel/built-in.o to 108 in mm/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_signalfd4' changed from 12 in 
kernel/built-in.o to 384 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_io_setup' changed from 12 in 
kernel/built-in.o to 1036 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_io_cancel' changed from 12 in 
kernel/built-in.o to 436 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_eventfd' changed from 12 in 
kernel/built-in.o to 24 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_epoll_create' changed from 12 in 
kernel/built-in.o to 48 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_ioprio_set' changed from 12 in 
kernel/built-in.o to 508 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_epoll_pwait' changed from 12 in 
kernel/built-in.o to 296 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_epoll_ctl' changed from 12 in 
kernel/built-in.o to 1052 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_epoll_wait' changed from 12 in 
kernel/built-in.o to 756 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_inotify_add_watch' changed from 12 
in kernel/built-in.o to 844 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_signalfd' changed from 12 in 
kernel/built-in.o to 24 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_eventfd2' changed from 12 in 
kernel/built-in.o to 112 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_epoll_create1' changed from 12 in 
kernel/built-in.o to 280 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_timerfd_settime' changed from 12 
in kernel/built-in.o to 480 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_inotify_init' changed from 12 in 
kernel/built-in.o to 24 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_inotify_init1' changed from 12 in 
kernel/built-in.o to 344 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_io_submit' changed from 12 in 
kernel/built-in.o to 1720 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_bdflush' changed from 12 in 
kernel/built-in.o to 156 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_timerfd_create' changed from 12 in 
kernel/built-in.o to 184 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_flock' changed from 12 in 
kernel/built-in.o to 344 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_timerfd_gettime' changed from 12 
in kernel/built-in.o to 360 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_inotify_rm_watch' changed from 12 
in kernel/built-in.o to 188 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_ioprio_get' changed from 12 in 
kernel/built-in.o to 648 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_io_getevents' changed from 12 in 
kernel/built-in.o to 1100 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_io_destroy' changed from 12 in 
kernel/built-in.o to 44 in fs/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_msgget' changed from 12 in 
kernel/built-in.o to 80 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_getsetattr' changed from 12 in 
kernel/built-in.o to 360 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_unlink' changed from 12 in 
kernel/built-in.o to 360 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_shmdt' changed from 12 in 
kernel/built-in.o to 160 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_msgrcv' changed from 12 in 
kernel/built-in.o to 88 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_open' changed from 12 in 
kernel/built-in.o to 796 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_semget' changed from 12 in 
kernel/built-in.o to 112 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_timedsend' changed from 12 in 
kernel/built-in.o to 628 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_semctl' changed from 12 in 
kernel/built-in.o to 240 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_notify' changed from 12 in 
kernel/built-in.o to 688 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_semtimedop' changed from 12 in 
kernel/built-in.o to 1580 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_shmctl' changed from 12 in 
kernel/built-in.o to 1260 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_mq_timedreceive' changed from 12 
in kernel/built-in.o to 692 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_msgsnd' changed from 12 in 
kernel/built-in.o to 72 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_semop' changed from 12 in 
kernel/built-in.o to 24 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_shmat' changed from 12 in 
kernel/built-in.o to 40 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_msgctl' changed from 12 in 
kernel/built-in.o to 880 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_shmget' changed from 12 in 
kernel/built-in.o to 88 in ipc/built-in.o
sh-uclinux-ld: Warning: size of symbol `__div64_32' changed from 56 in 
arch/sh/lib/lib.a(div64-generic.o) to 282 in lib/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_recv' changed from 12 in 
kernel/built-in.o to 32 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_setsockopt' changed from 12 in 
kernel/built-in.o to 216 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_recvfrom' changed from 12 in 
kernel/built-in.o to 264 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_accept4' changed from 12 in 
kernel/built-in.o to 352 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_socket' changed from 12 in 
kernel/built-in.o to 116 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_socketcall' changed from 12 in 
kernel/built-in.o to 640 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_listen' changed from 12 in 
kernel/built-in.o to 168 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_recvmsg' changed from 12 in 
kernel/built-in.o to 152 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_bind' changed from 12 in 
kernel/built-in.o to 148 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_send' changed from 12 in 
kernel/built-in.o to 32 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_accept' changed from 12 in 
kernel/built-in.o to 24 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_sendto' changed from 12 in 
kernel/built-in.o to 232 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_recvmmsg' changed from 12 in 
kernel/built-in.o to 196 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_getsockname' changed from 12 in 
kernel/built-in.o to 164 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_getsockopt' changed from 12 in 
kernel/built-in.o to 180 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_shutdown' changed from 12 in 
kernel/built-in.o to 132 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_sendmsg' changed from 12 in 
kernel/built-in.o to 536 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_connect' changed from 12 in 
kernel/built-in.o to 164 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_socketpair' changed from 12 in 
kernel/built-in.o to 312 in net/built-in.o
sh-uclinux-ld: Warning: size of symbol `sys_getpeername' changed from 12 in 
kernel/built-in.o to 164 in net/built-in.o
 
What can I check more over?

Thanks a lot


In data venerdì 26 marzo 2010 10:57:05, Andrew Stubbs ha scritto:
: > Fabio,
> 
> I hadn't noticed the problem because I've been using uImage.bin kernels
> (because they are compatible with the loader on my board).
> 
> I have reproduced the problem, but I don't have a fix for it. I think
> the problem is that 'elf32-shbig-linux' should be 'elf32-sh-fdpic' in
> this case.
> 
> BTW, I forgot to say, you'll need to enable the FDPIC binary loader, and
> it doesn't work without this patch:
> 
> diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
> index ac04255..b2fefb3 100644
> --- a/arch/sh/include/asm/elf.h
> +++ b/arch/sh/include/asm/elf.h
> @@ -211,15 +211,17 @@ extern void __kernel_vsyscall;
> 
>   #define VSYSCALL_AUX_ENT                                       \
>          if (vdso_enabled)                                       \
> -               NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);
> +               NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);        \
> +       else                                                    \
> +               NEW_AUX_ENT(AT_IGNORE, 0); /* Match AT_VECTOR_SIZE_ARCH. 
>  */ #else
> -#define VSYSCALL_AUX_ENT
> +#define VSYSCALL_AUX_ENT NEW_AUX_ENT(AT_IGNORE, 0);
>   #endif /* CONFIG_VSYSCALL */
> 
>   #ifdef CONFIG_SH_FPU
>   #define FPU_AUX_ENT    NEW_AUX_ENT(AT_FPUCW, FPSCR_INIT)
>   #else
> -#define FPU_AUX_ENT
> +#define FPU_AUX_ENT    NEW_AUX_ENT(AT_IGNORE, 0);
>   #endif
> 
>   extern int l1i_cache_shape, l1d_cache_shape, l2_cache_shape;
> 
> I've also submitted this to the kernel list.
> 
> Hope that helps,
> 
> Andrew
> 
> On 26/03/10 05:59, Fabio Giovagnini wrote:
> > Hi, Andrew,
> >
> > I execueted:
> >
> > $(MAKE) -C $(LINUX_DIR) ARCH=sh CROSS_COMPILE=sh-uclinux- zImage
> >
> > and I get this error
> >
> > sh-uclinux-objcopy -O binary -R .note -R .note.gnu.build-id -R .comment
> > -R .stab -R .stabstr -S -R .empty_zero_page vmlinux
> > arch/sh/boot/compressed/vmlinux.bin
> >
> > (cat arch/sh/boot/compressed/vmlinux.bin | gzip -f -9 >
> > arch/sh/boot/compressed/vmlinux.bin.gz) || (rm -f
> > arch/sh/boot/compressed/vmlinux.bin.gz ; false)
> >
> > sh-uclinux-ld -EB -r --format binary --oformat elf32-shbig-linux -T
> > arch/sh/boot/compressed/vmlinux.scr
> > arch/sh/boot/compressed/vmlinux.bin.gz -o arch/sh/boot/compressed/piggy.o
> >
> > sh-uclinux-ld -EB --oformat elf32-shbig-linux -Ttext 0x0c800000 -e
> > startup -T arch/sh/boot/compressed/../../kernel/vmlinux.lds
> > arch/sh/boot/compressed/head_32.o arch/sh/boot/compressed/misc.o
> > arch/sh/boot/compressed/cache.o arch/sh/boot/compressed/piggy.o
> > /home/fgiovagnini/sh7203/sh7203-uclinux-4.4-143/build/target/bin/../lib/g
> >cc/sh-uclinux/4.4.1/libgcc.a -o arch/sh/boot/compressed/vmlinux
> >
> > sh-uclinux-ld:
> > /home/fgiovagnini/sh7203/sh7203-uclinux-4.4-143/build/target/bin/../lib/g
> >cc/sh-uclinux/4.4.1/libgcc.a(_ashiftlt.o): attempt to mix FDPIC and
> > non-FDPIC objects
> >
> > sh-uclinux-ld: failed to merge target specific data of file
> > /home/fgiovagnini/sh7203/sh7203-uclinux-4.4-143/build/target/bin/../lib/g
> >cc/sh-uclinux/4.4.1/libgcc.a(_ashiftlt.o)
> >
> > sh-uclinux-ld:
> > /home/fgiovagnini/sh7203/sh7203-uclinux-4.4-143/build/target/bin/../lib/g
> >cc/sh-uclinux/4.4.1/libgcc.a(_lshiftrt.o): attempt to mix FDPIC and
> > non-FDPIC objects
> >
> > sh-uclinux-ld: failed to merge target specific data of file
> > /home/fgiovagnini/sh7203/sh7203-uclinux-4.4-143/build/target/bin/../lib/g
> >cc/sh-uclinux/4.4.1/libgcc.a(_lshiftrt.o)
> >
> > In data mercoledì 24 marzo 2010 17:39:59, Andrew Stubbs ha scritto:
> > : > On 24/03/10 05:32, Fabio Giovagnini wrote:
> >  > > Could yuo give me the permission to enabling me for downloading
> >  >
> >  > Hi Fabio,
> >  >
> >  >
> >  >
> >  > I could not give you permission to see the page I linked. :(
> >  >
> >  >
> >  >
> >  > However, I have added the installer downloads to your
> >  >
> >  > support.codesourcery.com homepage. Log in and you should see them:
> >  >
> >  >
> >  >
> >  > renesas-4.4-141-sh-uclinux.bin
> >  >
> >  > renesas-4.4-141-sh-uclinux.exe
> >  >
> >  >
> >  >
> >  > Let me know if you need any sources.
> >  >
> >  >
> >  >
> >  > We plan to make the final release next month, so please let me know of
> >  >
> >  > any issues you encounter as soon as possible.
> >  >
> >  >
> >  >
> >  > Thanks
> >  >
> >  >
> >  >
> >  > Andrew
> >
> > --
> >
> > Fabio Giovagnini
> >
> > Aurion s.r.l.
> >
> > P.I e C.F.
> >
> > 00885711200
> >
> > Tel. +39.051.594.78.24
> >
> > Cell. +39.335.83.50.919
> 

-- 
Fabio Giovagnini

Aurion s.r.l.
P.I e C.F.
00885711200
Tel. +39.051.594.78.24
Cell. +39.335.83.50.919
