Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0LUNwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:52:31 -0500
Received: from www.tglx.de ([62.245.132.106]:40475 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0LUNw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:52:29 -0500
Date: Tue, 21 Dec 2010 14:52:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 2.6.33.7-rt29
In-Reply-To: <alpine.LFD.2.00.1008031118270.3225@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1012211437120.12146@localhost6.localdomain6>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain> <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain> <alpine.LFD.2.00.1007311530510.2471@localhost.localdomain> <alpine.LFD.2.00.1008031118270.3225@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
  
Changes from 2.6.33.7-rt29 to 2.6.33.7.2-rt30:

5fed714: x86: stackprotector: Avoid random pool on rt
76bdf0c: x86: Convert mce timer to hrtimer
a1026af: net: ebtables: Work around per cpu assumptions
cfaca74: tracing: Add combined timer and wakeup latency histogram
e94445b: rt: mm: fix kthreadd livelock in drain_local_pages_work
a09b02c: powerpc/fsl-booke: Move loadcam_entry back to asm code to fix SMP ftrace
a8b8812: AT91: SAM9G45 - add a separate clock entry for every single TC block
3cf7bf5: mm: make stack guard page logic use vm_prev pointer
901f364: mm: make the mlock() stack guard page checks stricter
498f700: mm: make the vma list be doubly linked
e276f93c: mm: fix up some user-visible effects of the stack guard page
a487cf3: mm: fix page table unmap for stack guard page properly
27ed5f7: mm: fix missing page table unmap for stack guard page failure case
ed313b5: mm: keep a guard page below a grow-down stack segment
bf18be0: drm: block userspace under allocating buffer and having drivers overwrite it (v2)
3609ee7: x86-64, compat: Retruncate rax after ia32 syscall entry tracing
b2104d5: x86-64, compat: Test %rax for the syscall number, not %eax
c2841fe: compat: Make compat_alloc_user_space() incorporate the access_ok()
85b5abf: ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
5741fe4: wireless extensions: fix kernel heap content leak
49aa1d9: net sched: fix some kernel memory leaks
cd92f99: act_nat: use stack variable
dc7dde7: tracing: Do not allow llseek to set_ftrace_filter
2da92b6: x86: Limit 32bit PAE memory to 16G
1389ed5: niu: Fix kernel buffer overflow for ETHTOOL_GRXCLSRLALL
4d4ea8b: KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring
300f0c0: KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
300bc74: can: add limit for nframes and clean up signed/unsigned variables
88df886: NFS: Fix an Oops in the NFSv4 atomic open code
00b073d: staging/comedi: Fix type in semaphore conversion
327735e: perf: Provide kmap_atomic_direct for !CONFIG_HIGHMEM
ddeca62: perf: Use kmap_atomic_direct
d07d5cf: v2.6.33.7.1-rt29
e6c0211: ssb: Handle alternate SSPROM location
0bc60c2: ssb: fix NULL ptr deref when pcihost_wrapper is used
9ab4cde: ssb: Look for SPROM at different offset on higher rev CC
314beea: ssb: do not read SPROM if it does not exist
4ed85ce: Revert "ssb: Handle Netbook devices where the SPROM address is changed"
d4202e4: drm/i915: Check overlay stride errata for i830 and i845
60853cb: KVM: MMU: flush remote tlbs when overwriting spte with different pfn
fbbddb2: mac80211: avoid scheduling while atomic in mesh_rx_plink_frame
8d5c466: xen: drop xen_sched_clock in favour of using plain wallclock time
e4de451: CIFS: Fix compile error with __init in cifs_init_dns_resolver() definition
a9229e0: CIFS: Remove __exit mark from cifs_exit_dns_resolver()
ab006e3: slow-work: use get_ref wrapper instead of directly calling get_ref
7485c1e: GFS2: rename causes kernel Oops
432cfce: SCSI: enclosure: fix error path - actually return ERR_PTR() on error
127524e: xfs: prevent swapext from operating on write-only files
ab1b2be: cfg80211: don't get expired BSSes
d377614: cfg80211: ignore spurious deauth
efce9f4: iwlwifi: fix scan abort
8dc20bd: ath9k: fix yet another buffer leak in the tx aggregation code
9fd8aa6: ath9k: fix TSF after reset on AR913x
2089c7f: ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
e10e4ec: ath9k: enable serialize_regmode for non-PCIE AR9160
cad9c43: 9p: strlen() doesn't count the terminator
d2f1f93: e1000e: 82577/82578 PHY register access issues
8ed2a49: e1000e: don't inadvertently re-set INTX_DISABLE
257a4e8: amd64_edac: Correct scrub rate setting
3f5500c: amd64_edac: Fix DCT base address selector
8c0b0d6: parisc: pass through '\t' to early (iodc) console
d7e94ae: arm/imx/gpio: add spinlock protection
42aa826: PARISC: led.c - fix potential stack overflow in led_proc_write()
49337d1: NFS: kswapd must not block in nfs_release_page
7486bb3: comedi: Uncripple 8255-based DIO subdevices
6388252: mm: fix ia64 crash when gcore reads gate area

This is a rather large update with cherry-picks from the stable tree
and quite a few fixes for long standing problems in the rt patch.

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

To build the 2.6.33.7.2-rt30 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.7.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.7.2-rt30.bz2

Enjoy !

This is probably the last update to the 33-rt series.

The next release will be based on 2.6.37, but I'm still in the middle
of a major overhaul of key compononents of the patch. This overhaul is
necessary to make progress in mainlining the missing bits and
pieces. I hope to have it ready not too long after the 2.6.37 mainline
release, but no promise.

At this point I want to say thanks to everyone who supported the
development of the -rt patches with testing, bugfixes, stable
backports etc. in the last years. I hope that I can rely on your help
for the upcoming 37 release and the ongoing effort to merge the patch
fully into the mainline.

I wish you all a Merry Christmas and a Happy New Year!

       Thomas
