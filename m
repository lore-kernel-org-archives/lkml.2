Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1D3TqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 15:46:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1D3TqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 15:46:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.39-rc5-git4: Reported regressions from 2.6.38
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
Message-ID: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
Date: Sat, 30 Apr 2011 21:42:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE:
 I have one request for whoever works on fixing the listed regressions.  While
 your work is highly appreciated anyway, if you have a patch fixing a listed
 regression or you know of a commit fixing a listed regression, please drop
 a notice into the corresponding Bugzilla entry.  This will help us a lot.]  

This message contains a list of some regressions from 2.6.38,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.38, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-04-30       38       17          16
  2011-04-17       17       11          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34012
Subject		: 2.6.39-rc4+: oom-killer busy killing tasks
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2011-04-22 1:57 (9 days old)
Message-ID	: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
References	: http://marc.info/?l=linux-kernel&m=130343744622331&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34002
Subject		: [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2011-04-17 16:04 (14 days old)
Message-ID	: <201104171804.04664.maciej.rutecki@gmail.com>
References	: http://marc.info/?l=linux-fbdev&m=130305625114863&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33842
Subject		: NULL pointer dereference in ip_fragment
Submitter	: Tomas Carnecky <tom@dbservice.com>
Date		: 2011-04-23 07:51 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33812
Subject		: radeon with modeset option causes oops as secondary adapter (vgaswitcheroo)
Submitter	: Johannes Engel <jcnengel@googlemail.com>
Date		: 2011-04-21 23:14 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33792
Subject		: lockdep trace when unplugging usb audio (.39rc4)
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2011-04-19 18:07 (12 days old)
Message-ID	: <20110419180745.GA438@redhat.com>
References	: http://marc.info/?l=linux-kernel&m=130323648920431&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33492
Subject		: [bug] 2.6.39-rc3 fails to boot on Alpha
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2011-04-17 15:13 (14 days old)
Message-ID	: <19883.912.266127.538215@pilspetsen.it.uu.se>
References	: http://marc.info/?l=linux-kernel&m=130305321212360&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33482
Subject		: [Regression] Bluetooth pairing does not work anymore in 2.6.39-rc3 (works in 2.6.38.3)
Submitter	: Gottfried Haider <gottfried.haider@gmail.com>
Date		: 2011-04-16 16:38 (15 days old)
Message-ID	: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=130297197128328&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33432
Subject		: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
Submitter	: Ben Greear <greearb@candelatech.com>
Date		: 2011-04-13 16:29 (18 days old)
Message-ID	: <4DA5CF81.4070908@candelatech.com>
References	: http://marc.info/?l=linux-kernel&m=130271220809443&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33422
Subject		: oops in radeon_ddc_get_modes on first boot of rc3
Submitter	: Steve French <smfrench@gmail.com>
Date		: 2011-04-12 17:54 (19 days old)
Message-ID	: <BANLkTikTVuV9eH4GiLDs0DewGJXo_3daeg@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=130263086322702&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33402
Subject		: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2011-04-12 17:30 (19 days old)
Message-ID	: <19876.35918.322649.256455@pilspetsen.it.uu.se>
References	: http://marc.info/?l=linuxppc-embedded&m=130263128523237&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33302
Subject		: ACPI reboot broken on HP Compaq nx7300.
Submitter	: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Date		: 2011-04-15 14:44 (16 days old)
First-Bad-Commit: http://git.kernel.org/linus/3d35ac346e981162eeba391e496faceed4753e7b


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33272
Subject		: drm related hard-hang
Submitter	: Peter Teoh <htmldeveloper@gmail.com>
Date		: 2011-04-14 01:29 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
Subject		: Lockdep splat in autofs with 2.6.39-rc2
Submitter	: Nick Bowler <nbowler@elliptictech.com>
Date		: 2011-04-07 19:44 (24 days old)
Message-ID	: <20110407194403.GA29404@elliptictech.com>
References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33142
Subject		: 2.6.39-rc2 regression: X201s fails to resume b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Submitter	: Keith Packard <keithp@keithp.com>
Date		: 2011-04-06 7:44 (25 days old)
Message-ID	: <yun1v1fj024.fsf@aiko.keithp.com>
References	: http://marc.info/?l=linux-kernel&m=130207593728273&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33092
Subject		: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
Submitter	: Mark Jackson <mpfj-list@mimc.co.uk>
Date		: 2011-04-04 9:22 (27 days old)
First-Bad-Commit: http://git.kernel.org/linus/087809fce28f50098d9c3ef1a6865c722f23afd2
Message-ID	: <4D998DC9.3040109@mimc.co.uk>
References	: http://marc.info/?l=linux-kernel&m=130191386508831&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=32982
Subject		: Kernel locks up a few minutes after boot
Submitter	: Bart Van Assche <bart.vanassche@gmail.com>
Date		: 2011-04-10 19:55 (21 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33802
Subject		: list_del corruption in sd driver since 2.6.39-rc4
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2011-04-21 21:10 (10 days old)
Handled-By	: James Bottomley <James.Bottomley@suse.de>
Patch		: http://marc.info/?l=linux-kernel&m=130271409412095


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.38,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=32012

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

