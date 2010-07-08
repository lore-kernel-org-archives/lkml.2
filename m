Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0GHXuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:50:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab0GHXtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:49:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
Date: Fri,  9 Jul 2010 01:33:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.34,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.34, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-07-09       79       45          37
  2010-06-21       46       37          26
  2010-06-09       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16353
Subject		: 2.6.35 regression
Submitter	: Zeev Tarantov <zeev.tarantov@gmail.com>
Date		: 2010-07-05 13:04 (4 days old)
Message-ID	: <loom.20100705T144459-919@post.gmane.org>
References	: http://marc.info/?l=linux-kernel&m=127836002702522&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16346
Subject		: 2.6.35-rc3-git8 - include/linux/fdtable.h:88 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-07-04 22:04 (5 days old)
Message-ID	: <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127828107815930&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16337
Subject		: general protection fault: 0000 [#1] SMP
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2010-07-03 22:59 (6 days old)
Message-ID	: <4C2FC0E3.6050101@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127819798215589&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16334
Subject		: reiserfs locking (v2)
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-07-02 9:34 (7 days old)
Message-ID	: <20100702093451.GA3973@swordfish.minsk.epam.com>
References	: http://marc.info/?l=linux-kernel&m=127806306303590&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16333
Subject		: iwl3945: HARDWARE GONE??
Submitter	: Priit Laes <plaes@plaes.org>
Date		: 2010-07-02 16:02 (7 days old)
Message-ID	: <1278086575.2889.8.camel@chi>
References	: http://marc.info/?l=linux-kernel&m=127808659705983&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16332
Subject		: Kernel crashes in tty code (tty_open)
Submitter	: werner@guyane.yi.org
Date		: 2010-07-02 3:34 (7 days old)
Message-ID	: <1278041650.12788@guyane.yi.org>
References	: http://marc.info/?l=linux-kernel&m=127804167511930&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16330
Subject		: Dynamic Debug broken on 2.6.35-rc3?
Submitter	: Thomas Renninger <trenn@suse.de>
Date		: 2010-07-01 15:44 (8 days old)
Message-ID	: <201007011744.19564.trenn@suse.de>
References	: http://marc.info/?l=linux-kernel&m=127799907218877&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16329
Subject		: 2.6.35-rc3: Load average climbing to 3+ with no apparent reason: CPU 98% idle, with hardly no I/O
Submitter	: Török Edwin <edwintorok@gmail.com>
Date		: 2010-07-01 7:40 (8 days old)
Message-ID	: <20100701104022.404410d6@debian>
References	: http://marc.info/?l=linux-kernel&m=127797005030536&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16324
Subject		: Oops while running fs_racer test on a POWER6 box against latest git
Submitter	: divya <dipraksh@linux.vnet.ibm.com>
Date		: 2010-06-30 11:34 (9 days old)
Message-ID	: <4C2B28F3.7000006@linux.vnet.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127789697303061&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16323
Subject		: 2.6.35-rc3-git4 - kernel/sched.c:616 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-07-01 12:21 (8 days old)
Message-ID	: <AANLkTini6hz2LFeZi8CMUmY3xw1MU7NxmyesuxZ4oCdo@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127798693125541&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16322
Subject		: WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
Submitter	: boris64 <bugzilla.kernel.org@boris64.net>
Date		: 2010-07-01 13:54 (8 days old)
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-06-28 9:40 (11 days old)
Message-ID	: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16311
Subject		: [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2010-06-28 0:45 (11 days old)
Message-ID	: <201006272045.17004.shawn.starr@rogers.com>
References	: http://marc.info/?l=linux-kernel&m=127768633705286&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16309
Subject		: 2.6.35-rc3 oops trying to suspend.
Submitter	: Andrew Hendry <andrew.hendry@gmail.com>
Date		: 2010-06-27 12:40 (12 days old)
Message-ID	: <AANLkTinUH2p33-AWxOVDrLsNkn9rgEVrlwn5mfK7P8NH@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127764249926781&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16307
Subject		: i915 in kernel 2.6.35-rc3, high number of wakeups
Submitter	: Enrico Bandiello <enban@postal.uv.es>
Date		: 2010-06-26 16:57 (13 days old)
Message-ID	: <4C26317A.5070309@postal.uv.es>
References	: http://marc.info/?l=linux-kernel&m=127757403404259&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16306
Subject		: 2.6.35-rc3 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048 cifs_show_options
Submitter	: Andrew Hendry <andrew.hendry@gmail.com>
Date		: 2010-06-26 10:46 (13 days old)
Message-ID	: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127754922110501&w=2
Handled-By	: Jeff Layton <jlayton@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16304
Subject		: i915 - high number of wakeups
Submitter	: Enrico Bandiello <enban@postal.uv.es>
Date		: 2010-06-27 09:52 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
Subject		: [Q35 bisected] hang at init of i915 driver
Submitter	: Kees Cook <kees@outflux.net>
Date		: 2010-06-25 18:20 (14 days old)
First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16288
Subject		: kernel panic with iwlagn for Intel Wifi Link 5100
Submitter	:  <yanshuang.zheng@intel.com>
Date		: 2010-06-25 08:14 (14 days old)
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16284
Subject		: Hitting WARN_ON in hw_breakpoint code
Submitter	: Paul Mackerras <paulus@samba.org>
Date		: 2010-06-23 12:57 (16 days old)
Message-ID	: <20100623125740.GA3368@brick.ozlabs.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127729789113432&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16265
Subject		: Why is kslowd accumulating so much CPU time?
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2010-06-09 18:36 (30 days old)
First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
Message-ID	: <E1OMQ88-0002a1-Gb@closure.thunk.org>
References	: http://marc.info/?l=linux-kernel&m=127610857819033&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16257
Subject		: sysfs changes break hwsim and bnep drivers
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2010-06-20 11:23 (19 days old)
References	: http://thread.gmane.org/gmane.linux.network/162754
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
		  Kay Sievers <kay.sievers@vrfy.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16234
Subject		: [2.6.35-rc3] reboot mutex 'bug'...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2010-06-14 15:16 (25 days old)
Message-ID	: <AANLkTimDcTnyEPmt2ZcCM1UWtn4AYKotiqyjobJApkO7@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127652861118933&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16230
Subject		: inconsistent IN-HARDIRQ-W -> HARDIRQ-ON-W usage: fasync, 2.6.35-rc3
Submitter	: Dominik Brodowski <linux@dominikbrodowski.net>
Date		: 2010-06-13 9:53 (26 days old)
Message-ID	: <20100613095305.GA13231@comet.dominikbrodowski.net>
References	: http://marc.info/?l=linux-kernel&m=127642282208277&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16228
Subject		: BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Submitter	: Brian Bloniarz <phunge0@hotmail.com>
Date		: 2010-06-16 17:57 (23 days old)
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16221
Subject		: 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-06-11 20:31 (28 days old)
Message-ID	: <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127628828119623&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16205
Subject		: acpi: freeing invalid memtype bf799000-bf79a000
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2010-06-09 20:09 (30 days old)
Message-ID	: <20100609200910.GA2876@joi.lan>
References	: http://marc.info/?l=linux-kernel&m=127611427029914&w=2
		  http://marc.info/?l=linux-kernel&m=127688398513862&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16201
Subject		: SIOCGIWFREQ ioctl fails to get frequency info
Submitter	: nuh <nuh@mailinator.net>
Date		: 2010-06-14 10:45 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16199
Subject		: 2.6.35-rc2-git1 - include/linux/cgroup.h:534 invoked rcu_dereference_check() without protection!
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-06-07 18:14 (32 days old)
Message-ID	: <AANLkTin2pPqOUx--9fIX3BH3e-cU6oCRufijcx_4ozx5@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127593447812015&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16197
Subject		: [BUG on 2.6.35-rc2] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:11.0/0000:02:03.0/slot'
Submitter	: Ryan Wang <openspace.wang@gmail.com>
Date		: 2010-06-07 0:23 (32 days old)
Message-ID	: <AANLkTincwMZPnYW3S4uz4k2GOn52RpgBIBRfzyD010Yo@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127587022219378&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16187
Subject		: Carrier detection failed in dhcpcd when link is up
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-06-12 15:15 (27 days old)
First-Bad-Commit: http://git.kernel.org/linus/10708f37ae729baba9b67bd134c3720709d4ae62
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16184
Subject		: Container, X86-64, i386, iptables rule
Submitter	: Jean-Marc Pigeon <jmp@safe.ca>
Date		: 2010-06-12 04:17 (27 days old)
Handled-By	: Patrick McHardy <kaber@trash.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16179
Subject		: 2.6.35-rc2 completely hosed on intel gfx?
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2010-06-06 11:55 (33 days old)
Message-ID	: <20100606115534.GA9399@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=127582534931581&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16175
Subject		: 2.6.35-rc1 system oom, many processes killed but memory not free
Submitter	: andrew hendry <andrew.hendry@gmail.com>
Date		: 2010-06-05 0:46 (34 days old)
Message-ID	: <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127569877714937&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
Subject		: After uncompressing the kernel, at boot time, the server hangs.
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2010-06-09 23:25 (30 days old)
First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16145
Subject		: Unable to boot unless "notsc" or "clocksource=hpet", or acpi_pad disabling the TSC
Submitter	: Tom Gundersen <teg@jklm.no>
Date		: 2010-06-07 13:11 (32 days old)
Handled-By	: Venkatesh Pallipadi <venki@google.com>
		  Len Brown <lenb@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16122
Subject		: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2010-06-04 13:18 (35 days old)
Handled-By	: Jens Axboe <axboe@kernel.dk>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16310
Subject		: arm omap invalid module format
Submitter	: Robert Nelson <robertcnelson@gmail.com>
Date		: 2010-06-28 17:30 (11 days old)
First-Bad-Commit: http://git.kernel.org/linus/d0679c730395d0bde9a46939e7ba255b4ba7dd7c
Handled-By	: Michal Marek <mmarek@suse.cz>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26999


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16278
Subject		: lvm snapshot causes deadlock in 2.6.35
Submitter	: Phillip Susi <psusi@cfl.rr.com>
Date		: 2010-06-23 16:55 (16 days old)
Handled-By	: Eric Sandeen <sandeen@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26933


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16271
Subject		: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI related?]
Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
Date		: 2010-06-21 16:03 (18 days old)
Message-ID	: <1277136189.10998.63.camel@mulgrave.site>
References	: http://marc.info/?l=linux-kernel&m=127713622821166&w=2
Handled-By	: Len Brown <len.brown@intel.com>
Patch		: https://patchwork.kernel.org/patch/108497/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16256
Subject		: tpm_tis breaks suspend/hibernate on kernels > 2.6.34
Submitter	: Helmut Schaa <helmut.schaa@googlemail.com>
Date		: 2010-06-20 11:15 (19 days old)
First-Bad-Commit: http://git.kernel.org/linus/225a9be24d799aa16d543c31fb09f0c9ed1d9caa
Handled-By	: Helmut Schaa <helmut.schaa@googlemail.com>
Patch		: http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16255
Subject		: 2.6.35-rc3 deadlocks on semaphore operations
Submitter	: Christoph Lameter <cl@linux-foundation.org>
Date		: 2010-06-18 14:49 (21 days old)
Message-ID	: <alpine.DEB.2.00.1006180940140.11575@router.home>
References	: http://marc.info/?l=linux-kernel&m=127687262727707&w=2
Handled-By	: Manfred Spraul <manfred@colorfullife.com>
Patch		: http://marc.info/?l=linux-kernel&m=127731055203402&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16232
Subject		: 2.6.35-rc3 - WARNING:iwl_set_dynamic_key
Submitter	: Mario Guenterberg <mario.guenterberg@googlemail.com>
Date		: 2010-06-14 11:55 (25 days old)
Message-ID	: <20100614115510.GA7904@guenti-laptop>
References	: http://marc.info/?l=linux-kernel&m=127651695627147&w=2
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
Patch		: http://article.gmane.org/gmane.linux.kernel.wireless.general/52893


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16215
Subject		: sysfs: cannot create duplicate filename '/class/net/bnep0'
Submitter	: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date		: 2010-06-15 14:55 (24 days old)
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=16215#c10


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16169
Subject		: Complain from preemptive debug
Submitter	: Sedat Dilek <sedat.dilek@googlemail.com>
Date		: 2010-05-31 10:10 (39 days old)
Message-ID	: <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
References	: http://lkml.org/lkml/2010/5/31/77
Handled-By	: Dmitry Monakhov <dmonakhov@openvz.org>
		  Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Patch		: http://www.spinics.net/lists/cpufreq/msg01631.html
		  https://patchwork.kernel.org/patch/106555/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.34,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=16055

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

