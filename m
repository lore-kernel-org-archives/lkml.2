Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0HAOdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:33:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab0HAOdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:33:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.35-rc6-git6: Reported regressions 2.6.33 -> 2.6.34
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
Message-ID: <JKn8_uSlpqD.A.HLG.1LYVMB@chimera>
Date: Sun,  1 Aug 2010 16:27:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE: This is the last summary report of regressions introduced between
 2.6.33 and 2.6.34.  Thanks for helping us with tracking these bugs!]

This message contains a list of some post-2.6.33 regressions introduced before
2.6.34, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.33 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-08-01      129       17          16
  2010-07-23      128       27          25
  2010-07-10      122       25          24
  2010-06-21      114       36          28
  2010-06-13      111       40          34
  2010-05-09       80       27          24
  2010-05-04       76       26          22
  2010-04-20       64       35          34
  2010-04-07       48       35          33
  2010-03-21       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16431
Subject		: does not seem to shut down one of two md raid-1 arrays on hibernation
Submitter	: Martin Steigerwald <ms@teamix.de>
Date		: 2010-07-21 13:08 (12 days old)
Handled-By	: Neil Brown <neilb@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16388
Subject		: i915 drm BUG: unable to handle kernel paging request at a5e89046
Submitter	:  <lists@clanduggan.org>
Date		: 2010-07-14 16:59 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16377
Subject		: X.org crash while running a OpenGL composited KDE 4.4.4 session with Radeon KMS
Submitter	: Martin Steigerwald <Martin@Lichtvoll.de>
Date		: 2010-07-13 12:41 (20 days old)
Handled-By	: Alex Deucher <alexdeucher@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16376
Subject		: random - possibly Radeon DRM KMS related - freezes
Submitter	: Martin Steigerwald <Martin@Lichtvoll.de>
Date		: 2010-07-13 09:24 (20 days old)
Handled-By	: Alex Deucher <alexdeucher@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16320
Subject		: iwl3945 crashes, seems to be disconnecting from the PCI bus
Submitter	: Satish <eerpini@gmail.com>
Date		: 2010-07-01 08:24 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16300
Subject		: [2.6.34 regression] mplayer gets out of sync due to problems with ALSA
Submitter	: Artem S. Tashkinov <t.artem@mailcity.com>
Date		: 2010-06-26 20:39 (37 days old)
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16270
Subject		: Image is a hit-or-a-miss. Often displayed green+purple
Submitter	: Vish <drkvi-a@yahoo.com>
Date		: 2010-06-22 10:47 (41 days old)
First-Bad-Commit: http://git.kernel.org/linus/acef4a407ed6e0a9ed87a2747be592fe49e64bdd
Handled-By	: Jean-Francois Moine <moinejf@free.fr>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16206
Subject		: PROBLEM: PPP and other serial port related application hangs in kernel space
Submitter	: Ales Teska <ales.teska@gmail.com>
Date		: 2010-06-09 20:46 (54 days old)
Message-ID	: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127611640301071&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16170
Subject		: Leadtek Winfast DTV Dongle (STK7700P based) is not working in 2.6.34
Submitter	:  <macjariel@gmail.com>
Date		: 2010-06-09 11:11 (54 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16139
Subject		: wait_even_interruptible_timeout(), signal, spin_lock() = system hang
Submitter	: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date		: 2010-05-28 16:44 (66 days old)
Message-ID	: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127506510328758&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15977
Subject		: WARNING: at lib/dma-debug.c:866 check_for_stack
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-05-14 8:56 (80 days old)
Message-ID	: <AANLkTikyx2eaxaiUCFDSfpmn1UG0t2GOxArz6F4wp1LJ@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127382742729825&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15912
Subject		: Audio/video sync and crackling issues with snd-hda-intel (AD1981 codec)
Submitter	: Øyvind Stegard <oyvinst@ifi.uio.no>
Date		: 2010-05-05 16:20 (89 days old)
Handled-By	: Jaroslav Kysela <perex@perex.cz>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15862
Subject		: 2.6.34-rc4/5: iwlagn unusable until reload
Submitter	: Nico Schottelius <nico-linux-20100427@schottelius.org>
Date		: 2010-04-27 7:49 (97 days old)
Message-ID	: <20100427074934.GB3261@ikn.schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=127235784004839&w=2
Handled-By	: Johannes Berg <johannes@sipsolutions.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
Subject		: [r8169] WARNING: at net/sched/sch_generic.c
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-03-31 10:21 (124 days old)
Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-03-28 11:31 (127 days old)
Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15664
Subject		: Graphics hang and kernel backtrace when starting Azureus with Compiz enabled
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2010-04-01 01:09 (123 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16007
Subject		: x86/pci Oops with CONFIG_SND_HDA_INTEL
Submitter	: Graham Ramsey <ramsey.graham@ntlworld.com>
Date		: 2010-05-19 17:09 (75 days old)
Handled-By	: Yinghai Lu <yinghai@kernel.org>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: https://patchwork.kernel.org/patch/105662/


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.33 and 2.6.34, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=15310

Thanks!

