Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1BLXiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 18:38:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1BLXiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 18:38:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc4-git5: Reported regressions 2.6.36 -> 2.6.37
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
Message-ID: <9Pzlq5PlEtH.A.DU.efxVNB@chimera>
Date: Sun, 13 Feb 2011 00:34:02 +0100 (CET)
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
Date		: 2011-02-10 19:33 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28772
Subject		: oops in nfs_revalidate_mapping
Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Date		: 2011-02-10 13:59 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28662
Subject		: i915 in kernel 2.6.38-rc4, high number of wakeups
Submitter	: Kan-Ru Chen <kanru@kanru.info>
Date		: 2011-02-09 07:06 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28622
Subject		: radeon video lockup
Submitter	: Daniel Poelzleithner <bugzilla.kernel.org@poelzi.org>
Date		: 2011-02-08 17:48 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28612
Subject		: regular soft lockup
Submitter	: Alexandre Demers <alexandre.f.demers@gmail.com>
Date		: 2011-02-08 16:39 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28582
Subject		: whole system hang when start X
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2011-02-08 08:33 (5 days old)
First-Bad-Commit: http://git.kernel.org/linus/d5bb081b027b520f9e59b4fb8faea83a136ec15e


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28332
Subject		: [RV620] Can not re-enable LVDS after using HDMI only
Submitter	: Rafał Miłecki <zajec5@gmail.com>
Date		: 2011-02-05 22:42 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27892
Subject		: SNB: GPU hang with Slip xscreensaver
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2011-01-31 12:06 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27842
Subject		: [regression?] hang with 2.6.37 on a BTRFS test machine
Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
Date		: 2011-01-23 12:06 (21 days old)
Message-ID	: <<201101231306.23069.Martin@lichtvoll.de>>
References	: http://marc.info/?l=linux-kernel&m=129578445613283&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27642
Subject		: 2.6.37 says WARNING: at arch/x86/kernel/apic/apic.c:1287 setup_local_APIC+0x18f/0x263()
Submitter	: Rob Landley <rlandley@parallels.com>
Date		: 2011-01-18 13:11 (26 days old)
Message-ID	: <4D359188.3040408@parallels.com>
References	: http://marc.info/?l=linux-kernel&m=129535632319892&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27532
Subject		: ath9k prevents CPU from entering lower C-states
Submitter	: Thomas Bächler <thomas@archlinux.org>
Date		: 2011-01-24 22:43 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27402
Subject		: Atheros adapter no longer loads firmware
Submitter	: Michal Vaner <vorner@ucw.cz>
Date		: 2011-01-23 15:29 (21 days old)
First-Bad-Commit: http://git.kernel.org/linus/be93112accb42c5586a459683d71975cc70673ca


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27152
Subject		: VGA output broken at cold boot
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2011-01-20 13:26 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27132
Subject		: flush-btrfs gets into an infinite loop
Submitter	: Artem Anisimov <aanisimov@inbox.ru>
Date		: 2011-01-20 11:51 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26802
Subject		: b43: Suspend failed
Submitter	: Patrick Matthäi <patrick@linux-dev.org>
Date		: 2011-01-15 18:56 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26612
Subject		: BUG in fs/inode.c:429
Submitter	: Florian Kriener <florian@kriener.org>
Date		: 2011-01-06 16:35 (38 days old)
Message-ID	: <201101061735.40060.florian@kriener.org>
References	: http://marc.info/?l=linux-kernel&m=129433235223735&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26582
Subject		: NULL pointer dereference on pipe creation
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-01-12 13:30 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26112
Subject		: [LogFS] [2.6.37-rc8+] Kernel BUG at logfs/readwrite.c:297!
Submitter	: Prasad Joshi <prasadjoshi124@gmail.com>
Date		: 2011-01-02 21:22 (42 days old)
Message-ID	: <AANLkTinpoM8FuG8UkF88xs_V37dz_wgE8t-s0JPzaS-w@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=129400335910652&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=26102
Subject		: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
Submitter	: Pawel Sikora <pluto@agmk.net>
Date		: 2010-12-30 15:08 (45 days old)
Message-ID	: <201012301608.40859.pluto@agmk.net>
References	: http://marc.info/?l=linux-kernel&m=129372388925679&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25922
Subject		: IdeaPad Y530 brightness keys not functioning
Submitter	: Tomasz <tm.temp@gmx.com>
Date		: 2010-12-30 12:48 (45 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25832
Subject		: kernel crashes upon resume if usb devices are removed when suspended
Submitter	: rocko <rockorequin@hotmail.com>
Date		: 2010-12-29 11:47 (46 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25732
Subject		: i915 turns picture green when display switched off-on
Submitter	: Tõnu Raitviir <jussuf@linux.ee>
Date		: 2010-12-27 22:14 (48 days old)
First-Bad-Commit: http://git.kernel.org/linus/3c17fe4b8f40a112a85758a9ab2aebf772bdd647
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25072
Subject		: backlight level is not maintened during LID close/open
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2010-12-17 11:56 (58 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24882
Subject		: PM/Hibernate: Memory corruption patch introduces regression (2.6.36.2)
Submitter	:  <akwatts@ymail.com>
Date		: 2010-12-14 04:00 (61 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24822
Subject		: Embedded DisplayPort is detected wrongly on HP ProBook 5320m
Submitter	: Takashi Iwai <tiwai@suse.de>
Date		: 2010-12-13 11:09 (62 days old)
Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24762
Subject		: BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
Submitter	: Chris Wilson <chris@chris-wilson.co.uk>
Date		: 2010-12-10 12:00 (65 days old)
Message-ID	: <c6d829$pqibha@fmsmga001.fm.intel.com>
References	: http://marc.info/?l=linux-kernel&m=129198247531612&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24582
Subject		: Kernel Oops at tty_buffer_request_room when using pppd program (2.6.37-rc4)
Submitter	: baoyb <baoyb@avit.org.cn>
Date		: 2010-12-08 13:55 (67 days old)
Message-ID	: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb>
References	: http://marc.info/?l=linux-kernel&m=129181763525738&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22942
Subject		: [2.6.37-rc1, OOM] virtblk: OOM in do_virtblk_request()
Submitter	: Dave Chinner <david@fromorbit.com>
Date		: 2010-11-05 1:30 (100 days old)
Message-ID	: <20101105013003.GE13830@dastard>
References	: http://marc.info/?l=linux-kernel&m=128892062917641&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22642
Subject		: 2.6.37-rc1: Disk takes 10 seconds to resume - MacBook2,1
Submitter	: Tobias <devnull@plzk.org>
Date		: 2010-11-10 19:33 (95 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22542
Subject		: [2.6.37-rc1] drm:i195 errors
Submitter	: Paul Rolland <rol@witbe.net>
Date		: 2010-11-02 14:58 (103 days old)
Message-ID	: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
References	: http://marc.info/?l=linux-kernel&m=128870991628970&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28592
Subject		: Multichannels LPCM through HDMI audio does not work anymore on NVidia cards
Submitter	: dura <newsgrp@duradsl.dyndns.org>
Date		: 2011-02-08 13:39 (5 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=46852


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27202
Subject		: Remote control of saa7134-based tv card "ASUSTeK P7131 Hybrid" stopped working in 2.6.37
Submitter	:  <acaizzo@gmail.com>
Date		: 2011-01-20 17:23 (24 days old)
First-Bad-Commit: http://git.kernel.org/linus/4651918a4afdd49bdea21d2f919b189ef17a6399
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=44532


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25822
Subject		: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
Submitter	: Gurudas Pai <gurudas.pai@oracle.com>
Date		: 2010-12-29 6:58 (46 days old)
Message-ID	: <4D1AD935.1020504@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=129360511222037&w=2
Patch		: https://lkml.org/lkml/2010/12/29/131
		  https://lkml.org/lkml/2011/1/20/163


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25402
Subject		: kernel (2.6.37-8-generic_amd64) panic on boot (with message "map_single: bounce buffer is not DMA'ble) - possible regression !!!
Submitter	: carlos <carlos.palma@ono.com>
Date		: 2010-12-21 19:58 (54 days old)
Patch		: https://patchwork.kernel.org/patch/522971/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23472
Subject		: 2.6.37-rc2 vs. 2.6.36 laptop backlight changes?
Submitter	: Patrick Schaaf <netdev@bof.de>
Date		: 2010-11-17 13:41 (88 days old)
Message-ID	: <1290001262.5727.2.camel@lat1>
References	: http://marc.info/?l=linux-kernel&m=129000127920912&w=2
Handled-By	: Indan Zupancic <indan@nul.nu>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=47302


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22882
Subject		: (2.6.37-rc1) amd64-agp module crashed on second load
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-11-05 0:13 (100 days old)
Message-ID	: <20101104171333.fea1f498.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=128891605213447&w=2
Handled-By	: Florian Mickler <florian@mickler.org>
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=46682


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.36 and 2.6.37, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=21782

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

