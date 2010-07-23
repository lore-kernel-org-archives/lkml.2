Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0GWLpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:45:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0GWLpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:45:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc6: Reported regressions from 2.6.34
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
Date: Fri, 23 Jul 2010 13:42:26 +0200 (CEST)
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
  2010-07-23       94       33          25
  2010-07-09       79       45          37
  2010-06-21       46       37          26
  2010-06-09       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16423
Subject		: netfilter/iptables stopped logging 2.6.35-rc
Submitter	: auto401300@hushmail.com
Date		: 2010-07-17 10:20 (7 days old)
Message-ID	: <20100717072036.1BBE52804B@smtp.hushmail.com>
References	: http://lkml.indiana.edu/hypermail/linux/kernel/1007.2/00440.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16406
Subject		: Badness with the kernel version 2.6.35-rc1-git1 running on P6 box
Submitter	: divya <dipraksh@linux.vnet.ibm.com>
Date		: 2010-07-16 8:50 (8 days old)
Message-ID	: <4C401D56.3070108@linux.vnet.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127927024906085&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16405
Subject		: Brightness Adjustment on Toshiba nb305 Netbooks is non-functional.
Submitter	: John Mesmon <jmesmon@gmail.com>
Date		: 2010-07-15 23:40 (9 days old)
First-Bad-Commit: http://git.kernel.org/linus/74a365b3f354fafc537efa5867deb7a9fadbfe27
Handled-By	: Matthew Garrett <mjg59-kernel@srcf.ucam.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16400
Subject		: 2.6.35-rc5 inconsistent lock state
Submitter	: Martin Pirker <lkml.collector@gmail.com>
Date		: 2010-07-14 20:33 (10 days old)
Message-ID	: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127913961025267&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16399
Subject		: perf failed with kernel 2.6.35-rc
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2010-07-13 8:14 (11 days old)
First-Bad-Commit: http://git.kernel.org/linus/1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
Message-ID	: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=127900880212470&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16393
Subject		: kernel BUG at fs/block_dev.c:765!
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2010-07-14 13:52 (10 days old)
Message-ID	: <20100714135217.GA1797@arch.tripp.de>
References	: http://marc.info/?l=linux-kernel&m=127911564213748&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16392
Subject		: BUG at arch/x86/mm/physaddr.c:5
Submitter	: Ortwin Glück <odi@odi.ch>
Date		: 2010-07-14 6:54 (10 days old)
Message-ID	: <4C3D5F3F.7070901@odi.ch>
References	: http://marc.info/?l=linux-kernel&m=127909052705341&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16383
Subject		: Regression with e1000e from 2.6.34.1 to 2.6.35-rc5
Submitter	: Stefan Behte <craig@haquarter.de>
Date		: 2010-07-14 00:44 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16380
Subject		: Loop devices act strangely in 2.6.35
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2010-07-13 23:21 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16372
Subject		: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
Submitter	: Torsten Kaiser <just.for.lkml@googlemail.com>
Date		: 2010-07-11 19:56 (13 days old)
Message-ID	: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127887822407672&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16369
Subject		: Yet another 2.6.35 regression (AGP)?
Submitter	: Woody Suwalski <terraluna977@gmail.com>
Date		: 2010-07-09 14:21 (15 days old)
Message-ID	: <4C373084.8000503@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127868797119254&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16365
Subject		: kernel BUG at fs/btrfs/extent-tree.c:1353
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-07-08 14:27 (16 days old)
Message-ID	: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de>
References	: http://marc.info/?l=linux-kernel&m=127859960725931&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16337
Subject		: general protection fault: 0000 [#1] SMP
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2010-07-03 22:59 (21 days old)
Message-ID	: <4C2FC0E3.6050101@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127819798215589&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16332
Subject		: Kernel crashes in tty code (tty_open)
Submitter	: werner@guyane.yi.org
Date		: 2010-07-02 3:34 (22 days old)
Message-ID	: <1278041650.12788@guyane.yi.org>
References	: http://marc.info/?l=linux-kernel&m=127804167511930&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16322
Subject		: WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
Submitter	: boris64 <bugzilla.kernel.org@boris64.net>
Date		: 2010-07-01 13:54 (23 days old)
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-06-28 9:40 (26 days old)
Message-ID	: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16311
Subject		: [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
Submitter	: Shawn Starr <shawn.starr@rogers.com>
Date		: 2010-06-28 0:45 (26 days old)
Message-ID	: <<201006272045.17004.shawn.starr@rogers.com>>
References	: http://marc.info/?l=linux-kernel&m=127768633705286&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16307
Subject		: i915 in kernel 2.6.35-rc3, high number of wakeups
Submitter	: Enrico Bandiello <enban@postal.uv.es>
Date		: 2010-06-26 16:57 (28 days old)
Message-ID	: <4C26317A.5070309@postal.uv.es>
References	: http://marc.info/?l=linux-kernel&m=127757403404259&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16265
Subject		: Why is kslowd accumulating so much CPU time?
Submitter	: Theodore Ts'o <tytso@mit.edu>
Date		: 2010-06-09 18:36 (45 days old)
First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
Message-ID	: <E1OMQ88-0002a1-Gb@closure.thunk.org>
References	: http://marc.info/?l=linux-kernel&m=127610857819033&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16257
Subject		: sysfs changes break hwsim and bnep drivers
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2010-06-20 11:23 (34 days old)
References	: http://thread.gmane.org/gmane.linux.network/162754
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
		  Kay Sievers <kay.sievers@vrfy.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16228
Subject		: BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
Submitter	: Brian Bloniarz <phunge0@hotmail.com>
Date		: 2010-06-16 17:57 (38 days old)
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16221
Subject		: 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-06-11 20:31 (43 days old)
Message-ID	: <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127628828119623&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16201
Subject		: SIOCGIWFREQ ioctl fails to get frequency info
Submitter	: nuh <nuh@mailinator.net>
Date		: 2010-06-14 10:45 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16184
Subject		: Container, X86-64, i386, iptables rule
Submitter	: Jean-Marc Pigeon <jmp@safe.ca>
Date		: 2010-06-12 04:17 (42 days old)
Handled-By	: Patrick McHardy <kaber@trash.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
Subject		: After uncompressing the kernel, at boot time, the server hangs.
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2010-06-09 23:25 (45 days old)
First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16396
Subject		: [bisected] resume from suspend freezes system
Submitter	: tomas m <tmezzadra@gmail.com>
Date		: 2010-07-15 02:32 (9 days old)
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://patchwork.kernel.org/patch/113108/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16353
Subject		: 2.6.35 regression
Submitter	: Zeev Tarantov <zeev.tarantov@gmail.com>
Date		: 2010-07-05 13:04 (19 days old)
Message-ID	: <loom.20100705T144459-919@post.gmane.org>
References	: http://marc.info/?l=linux-kernel&m=127836002702522&w=2
Handled-By	: Steven Rostedt <rostedt@goodmis.org>
Patch		: https://patchwork.kernel.org/patch/110988/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16310
Subject		: arm omap invalid module format
Submitter	: Robert Nelson <robertcnelson@gmail.com>
Date		: 2010-06-28 17:30 (26 days old)
First-Bad-Commit: http://git.kernel.org/linus/d0679c730395d0bde9a46939e7ba255b4ba7dd7c
Handled-By	: Michal Marek <mmarek@suse.cz>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26999


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
Subject		: [Q35 bisected] hang at init of i915 driver
Submitter	: Kees Cook <kees@outflux.net>
Date		: 2010-06-25 18:20 (29 days old)
First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
Handled-By	: Tim Gardner <tim.gardner@canonical.com>
Patch		: https://patchwork.kernel.org/patch/111130/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16278
Subject		: lvm snapshot causes deadlock in 2.6.35
Submitter	: Phillip Susi <psusi@cfl.rr.com>
Date		: 2010-06-23 16:55 (31 days old)
Handled-By	: Eric Sandeen <sandeen@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=26933


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16271
Subject		: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI related?]
Submitter	: James Bottomley <James.Bottomley@hansenpartnership.com>
Date		: 2010-06-21 16:03 (33 days old)
Message-ID	: <1277136189.10998.63.camel@mulgrave.site>
References	: http://marc.info/?l=linux-kernel&m=127713622821166&w=2
Handled-By	: Len Brown <len.brown@intel.com>
Patch		: https://patchwork.kernel.org/patch/108497/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16256
Subject		: tpm_tis breaks suspend/hibernate on kernels > 2.6.34
Submitter	: Helmut Schaa <helmut.schaa@googlemail.com>
Date		: 2010-06-20 11:15 (34 days old)
First-Bad-Commit: http://git.kernel.org/linus/225a9be24d799aa16d543c31fb09f0c9ed1d9caa
Handled-By	: Helmut Schaa <helmut.schaa@googlemail.com>
Patch		: http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16215
Subject		: sysfs: cannot create duplicate filename '/class/net/bnep0'
Submitter	: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date		: 2010-06-15 14:55 (39 days old)
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=16215#c10


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.34,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=16055

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

