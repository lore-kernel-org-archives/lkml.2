Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1CFMpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:45:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab1CFMpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:45:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc7-git4: Reported regressions 2.6.36 -> 2.6.37
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
Message-ID: <dtUMITvTCCN.A.uuF.y-3cNB@chimera>
Date: Sun,  6 Mar 2011 13:34:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some post-2.6.36 regressions introduced before
2.6.37, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.36 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-03-06      132       28          23
  2011-02-21      128       35          26
  2011-02-13      126       36          30
  2011-02-03      118       36          31
  2010-12-30       85       32          26
  2010-12-19       73       28          24
  2010-12-03       55       25          19
  2010-11-19       39       29          25


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28812
Subject		: DVI attached monitor is turned off while booting linux 2.6.37 and higher
Submitter	: Markus Heinz <markus.heinz@uni-dortmund.de>
Date		: 2011-02-10 19:33 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28772
Subject		: oops in nfs_revalidate_mapping
Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Date		: 2011-02-10 13:59 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28662
Subject		: i915 in kernel 2.6.38-rc4, high number of wakeups
Submitter	: Kan-Ru Chen <kanru@kanru.info>
Date		: 2011-02-09 07:06 (26 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28622
Subject		: radeon video lockup
Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Date		: 2011-02-08 17:48 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28612
Subject		: regular soft lockup
Submitter	: Alexandre Demers <alexandre.f.demers@gmail.com>
Date		: 2011-02-08 16:39 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28582
Subject		: whole system hang when start X
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2011-02-08 08:33 (27 days old)
First-Bad-Commit: http://git.kernel.org/linus/d5bb081b027b520f9e59b4fb8faea83a136ec15e


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28332
Subject		: [RV620] Can not re-enable LVDS after using HDMI only
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2011-02-05 22:42 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27892
Subject		: SNB: GPU hang with Slip xscreensaver
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2011-01-31 12:06 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27842
Subject		: [regression?] hang with 2.6.37 on a BTRFS test machine
Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
Date		: 2011-01-23 12:06 (43 days old)
Message-ID	: <<201101231306.23069.Martin@lichtvoll.de>>
References	: http://marc.info/?l=linux-kernel&m=129578445613283&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27642
Subject		: 2.6.37 says WARNING: at arch/x86/kernel/apic/apic.c:1287 setup_local_APIC+0x18f/0x263()
Submitter	: Rob Landley <rlandley@parallels.com>
Date		: 2011-01-18 13:11 (48 days old)
Message-ID	: <4D359188.3040408@parallels.com>
References	: http://marc.info/?l=linux-kernel&m=129535632319892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27152
Subject		: VGA output broken at cold boot
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2011-01-20 13:26 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27132
Subject		: flush-btrfs gets into an infinite loop
Submitter	: Artem Anisimov <aanisimov@inbox.ru>
Date		: 2011-01-20 11:51 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26802
Subject		: b43: Suspend failed
Submitter	: Patrick Matthäi <patrick@linux-dev.org>
Date		: 2011-01-15 18:56 (51 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26612
Subject		: BUG in fs/inode.c:429
Submitter	: Florian Kriener <florian@kriener.org>
Date		: 2011-01-06 16:35 (60 days old)
Message-ID	: <201101061735.40060.florian@kriener.org>
References	: http://marc.info/?l=linux-kernel&m=129433235223735&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26582
Subject		: NULL pointer dereference on pipe creation
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-01-12 13:30 (54 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26112
Subject		: [LogFS] [2.6.37-rc8+] Kernel BUG at logfs/readwrite.c:297!
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2011-01-02 21:22 (64 days old)
Message-ID	: <AANLkTinpoM8FuG8UkF88xs_V37dz_wgE8t-s0JPzaS-w@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129400335910652&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26102
Subject		: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
Submitter	: Pawel Sikora <pluto@agmk.net>
Date		: 2010-12-30 15:08 (67 days old)
Message-ID	: <201012301608.40859.pluto@agmk.net>
References	: http://marc.info/?l=linux-kernel&m=129372388925679&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26042
Subject		: BUG: NULL pointer dereference at shrink_dcache_parent
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-01-03 10:49 (63 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25832
Subject		: kernel crashes upon resume if usb devices are removed when suspended
Submitter	: rocko <rockorequin@hotmail.com>
Date		: 2010-12-29 11:47 (68 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25732
Subject		: i915 turns picture green when display switched off-on
Submitter	: Tõnu Raitviir <jussuf@linux.ee>
Date		: 2010-12-27 22:14 (70 days old)
First-Bad-Commit: http://git.kernel.org/linus/3c17fe4b8f40a112a85758a9ab2aebf772bdd647
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24822
Subject		: Embedded DisplayPort is detected wrongly on HP ProBook 5320m
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2010-12-13 11:09 (84 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22942
Subject		: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Submitter	: Dave Chinner <david@fromorbit.com>
Date		: 2010-11-05 1:30 (122 days old)
Message-ID	: <20101105013003.GE13830@dastard>
References	: http://marc.info/?l=linux-kernel&m=128892062917641&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22642
Subject		: 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
Submitter	: Tobias <devnull@plzk.org>
Date		: 2010-11-10 19:33 (117 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=30322
Subject		: BUG in xs_tcp_setup_socket
Submitter	: Ben Hutchings <bhutchings@solarflare.com>
Date		: 2011-03-01 20:34 (6 days old)
Patch		: http://article.gmane.org/gmane.linux.nfs/38949


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29722
Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w after resume
Submitter	: Ortwin Glück <odi@odi.ch>
Date		: 2011-02-23 11:49 (12 days old)
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: https://patchwork.kernel.org/patch/604371/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27202
Subject		: Remote control of saa7134-based tv card "ASUSTeK P7131 Hybrid" stopped working in 2.6.37
Submitter	:  <acaizzo@gmail.com>
Date		: 2011-01-20 17:23 (46 days old)
First-Bad-Commit: http://git.kernel.org/linus/4651918a4afdd49bdea21d2f919b189ef17a6399
Handled-By	: Mauro Carvalho Chehab <mchehab@redhat.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=44532


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25922
Subject		: IdeaPad Y530 brightness keys not functioning
Submitter	: Tomasz <tm.temp@gmx.com>
Date		: 2010-12-30 12:48 (67 days old)
Handled-By	: Ike Panhc <ikepanhc@gmail.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=48702


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24982
Subject		: Inconsistent DPMS handling with 2.6.37 DRM
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2010-12-16 16:32 (81 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Keith Packard <keithp@keithp.com>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=40392
		  https://patchwork.kernel.org/patch/530921/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.36 and 2.6.37, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=21782

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

