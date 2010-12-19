Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0LSMd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:33:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0LSMdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:33:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.37-rc6-git4: Reported regressions from 2.6.36
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
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
Message-ID: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
Date: Sun, 19 Dec 2010 13:28:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.36,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.36, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-12-19       73       28          24
  2010-12-03       55       25          19
  2010-11-19       39       29          25


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25012
Subject		: BUG: i915 causes NULL pointer dereference in 2.6.37-rc5-git4
Submitter	: Tõnu Raitviir <jussuf@linux.ee>
Date		: 2010-12-15 12:48 (5 days old)
Message-ID	: <alpine.DEB.2.00.1012151238570.4797@jbbyvx.ohzcpyho.rr>
References	: http://www.spinics.net/lists/dri-devel/msg06282.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24892
Subject		: Wireless warning, system locks up
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-12-14 15:16 (6 days old)
Handled-By	: John W. Linville <linville@tuxdriver.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24882
Subject		: PM/Hibernate: Memory corruption patch introduces regression (2.6.36.2)
Submitter	:  <akwatts@ymail.com>
Date		: 2010-12-14 04:00 (6 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24822
Subject		: Embedded DisplayPort is detected wrongly on HP ProBook 5320m
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2010-12-13 11:09 (7 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24772
Subject		: Crash with btrfs rootfs on dm-crypt [ kernel BUG at fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
Submitter	: Fabio Comolli <fabio.comolli@gmail.com>
Date		: 2010-12-10 20:30 (10 days old)
Message-ID	: <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129201308706568&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24762
Subject		: BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
Submitter	: Chris Wilson <chris@chris-wilson.co.uk>
Date		: 2010-12-10 12:00 (10 days old)
Message-ID	: <c6d829$pqibha@fmsmga001.fm.intel.com>
References	: http://marc.info/?l=linux-kernel&m=129198247531612&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24722
Subject		: Disconnecting my USB mouse hangs the machine and issues kernel warning
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-12-12 12:42 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24592
Subject		: 2.6.37-rc5: NULL pointer oops in selinux_socket_unix_stream_connect
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2010-12-08 21:09 (12 days old)
Message-ID	: <4CFFF3F3.90100@goop.org>
References	: http://marc.info/?l=linux-kernel&m=129184256629712&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24582
Subject		: Kernel Oops at tty_buffer_request_room when using pppd program (2.6.37-rc4)
Submitter	: baoyb <baoyb@avit.org.cn>
Date		: 2010-12-08 13:55 (12 days old)
Message-ID	: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
References	: http://marc.info/?l=linux-kernel&m=129181763525738&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24372
Subject		: kdump broken on 2.6.37-rc4
Submitter	: Stanislaw Gruszka <sgruszka@redhat.com>
Date		: 2010-12-03 11:16 (17 days old)
Message-ID	: <20101203111623.GA2741@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=129137502323003&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24362
Subject		: perf hw  in kexeced kernel broken in tip
Submitter	: Yinghai Lu <yinghai@kernel.org>
Date		: 2010-12-01 8:00 (19 days old)
First-Bad-Commit: http://git.kernel.org/linus/33c6d6a7ad0ffab9b1b15f8e4107a2af072a05a0
Message-ID	: <4CF60095.1020900@kernel.org>
References	: http://marc.info/?l=linux-kernel&m=129119055922065&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24272
Subject		: iotop reports insane per-process disk read/write statistics
Submitter	: Brian Rogers <brian@xyzw.org>
Date		: 2010-12-03 12:00 (17 days old)
First-Bad-Commit: http://git.kernel.org/linus/85893120699f8bae8caa12a8ee18ab5fceac978e


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24142
Subject		: Crash at boot in udev while accessing bt848 device in 2.6.37-rc*
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-11-30 20:50 (20 days old)
References	: https://bugzilla.kernel.org/show_bug.cgi?id=24602


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23902
Subject		: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2010-11-27 15:16 (23 days old)
First-Bad-Commit: http://git.kernel.org/linus/305e6835e05513406fa12820e40e4a8ecb63743c
Message-ID	: <<19697.8378.717761.236202@pilspetsen.it.uu.se>>
References	: http://marc.info/?l=linux-kernel&m=129087098911837&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23472
Subject		: 2.6.37-rc2 vs. 2.6.36 laptop backlight changes?
Submitter	: Patrick Schaaf <netdev@bof.de>
Date		: 2010-11-17 13:41 (33 days old)
Message-ID	: <1290001262.5727.2.camel@lat1>
References	: http://marc.info/?l=linux-kernel&m=129000127920912&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23102
Subject		: [bisected] i915 regression in post 2.6.36 kernels
Submitter	: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Date		: 2010-11-10 7:02 (40 days old)
Message-ID	: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
References	: http://marc.info/?l=linux-kernel&m=128937310017057&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22942
Subject		: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Submitter	: Dave Chinner <david@fromorbit.com>
Date		: 2010-11-05 1:30 (45 days old)
Message-ID	: <20101105013003.GE13830@dastard>
References	: http://marc.info/?l=linux-kernel&m=128892062917641&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22912
Subject		: spi_lm70llp module crash on unload (2.6.37-rc1)
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-11-05 0:16 (45 days old)
Message-ID	: <20101104171620.00d8c95d.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=128891627913647&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22882
Subject		: (2.6.37-rc1) amd64-agp module crashed on second load
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-11-05 0:13 (45 days old)
Message-ID	: <20101104171333.fea1f498.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=128891605213447&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22812
Subject		: kernel oops on 2.6.37-rc1
Submitter	: Andrew <atswartz@gmail.com>
Date		: 2010-11-12 16:05 (38 days old)
First-Bad-Commit: http://git.kernel.org/linus/a68c439b1966c91f0ef474e2bf275d6792312726


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22642
Subject		: 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
Submitter	: Tobias <devnull@plzk.org>
Date		: 2010-11-10 19:33 (40 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22562
Subject		: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2010-11-02 22:32 (48 days old)
First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
Message-ID	: <4CD09166.4060202@lwfinger.net>
References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22542
Subject		: [2.6.37-rc1] drm:i195 errors
Submitter	: Paul Rolland <rol@witbe.net>
Date		: 2010-11-02 14:58 (48 days old)
Message-ID	: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
References	: http://marc.info/?l=linux-kernel&m=128870991628970&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22472
Subject		: vga_switcheroo fails to switch from intel to ati
Submitter	: Radu Andries <admiral0@tuxfamily.org>
Date		: 2010-11-08 16:46 (42 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24602
Subject		: modprobe bttv crashes system
Submitter	: Sergej Pupykin <pupykin.s@gmail.com>
Date		: 2010-12-09 21:48 (11 days old)
References	: https://bugzilla.kernel.org/show_bug.cgi?id=24142
Patch		: https://patchwork.kernel.org/patch/414671/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24462
Subject		: r600: spread spectrum: flickering screen (bisected)
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2010-12-08 16:18 (12 days old)
First-Bad-Commit: http://git.kernel.org/linus/ba032a58d1f320039e7850fb6e8651695c1aa571
Handled-By	: Alex Deucher <alexdeucher@gmail.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=39372


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22672
Subject		: Regression in 2.6.37-rc1 for Intel 945 Graphics Adapter - bisected to commit e9e331a
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2010-11-11 01:56 (39 days old)
References	: https://bugs.freedesktop.org/show_bug.cgi?id=31803
		  http://marc.info/?l=linux-kernel&m=128944001311444&w=2
		  http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg02235.html
Patch		: https://patchwork.kernel.org/patch/359472/
		  https://patchwork.kernel.org/patch/359502/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22662
Subject		: divide error in select_task_rq_fair()
Submitter	: Myron Stowe <myron.stowe@hp.com>
Date		: 2010-11-10 23:58 (40 days old)
Patch		: http://lkml.org/lkml/2010/11/13/176
		  http://lkml.org/lkml/2010/11/13/181


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.36,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=21782

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

