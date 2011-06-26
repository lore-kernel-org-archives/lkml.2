Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1FZWtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:49:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab1FZWsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:48:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.0-rc4: Reported regressions 2.6.38 -> 2.6.39
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
Message-ID: <fvHbBUhG0PD.A.IGE.HM7BOB@chimera>
Date: Mon, 27 Jun 2011 00:26:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some post-2.6.38 regressions introduced before
2.6.39, for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved post-2.6.38 regressions, please let us know
either and we'll add them to the list.  Also, please let us know if any
of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2011-06-27       94       25          23
  2011-06-12       81       21          18
  2011-05-15       50       12          11
  2011-04-30       38       17          16
  2011-04-17       17       11          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=38132
Subject		: [OOPS] 2.6.39.x latencytop
Submitter	: Andrew Watts <akwatts@ymail.com>
Date		: 2011-06-14 17:07 (13 days old)
Message-ID	: <80098.5633.qm@web111013.mail.gq1.yahoo.com>
References	: http://marc.info/?l=linux-kernel&m=130807128506490&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37772
Subject		: Sometimes, sound disappears and doesn't want to idle.
Submitter	:  <merkil@savhon.org>
Date		: 2011-06-17 22:06 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37752
Subject		: Kernel Panic in drm_vblank_put+0x13/0x50 on P4 HT machine with 82915G/GV/910GL Integrated Graphics Controller
Submitter	: Martin Rogge <marogge@onlinehome.de>
Date		: 2011-06-17 13:02 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37712
Subject		: reboot  / "shutdown -r now" hangs ;  works fine on 2.6.38.7-1
Submitter	: Dave Hooper <dave@beermex.com>
Date		: 2011-06-16 20:50 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37692
Subject		: Linux 2.6.39.x fails to boot - unable to mount root fs
Submitter	: Dan Dart <dandart@googlemail.com>
Date		: 2011-06-16 18:55 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37622
Subject		: Poor wireless performance with Intel 4965AGN with iwl-legacy/iwl4965
Submitter	:  <MDstr_1@hotmail.com>
Date		: 2011-06-16 11:22 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37472
Subject		: Lenovo U160 (i915 black screen)
Submitter	: Robse <rob-se@live.de>
Date		: 2011-06-14 15:17 (13 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37322
Subject		: high load, unresponsive system spinning in rcu_kthread
Submitter	: Ferenc Wágner <wferi@niif.hu>
Date		: 2011-06-12 14:53 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37312
Subject		: Intel 5100 wifi stopped working with 2.6.39.1
Submitter	: Thibault Dory <dory.thibault@gmail.com>
Date		: 2011-06-12 12:43 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37292
Subject		: kernel BUG at fs/ecryptfs/read_write.c:47!
Submitter	:  <rems14@lestoutous.com>
Date		: 2011-06-12 10:25 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37042
Subject		: linux 3.0.0-rc2 libata-eh.c:4018 ata_scsi_port_error_handler+0x80/0x53d on s2disk
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2011-06-09 08:22 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36952
Subject		: [2.6.39] CIFS write failures where 2.6.38 works
Submitter	: Helge Hafting <helge.hafting@hist.no>
Date		: 2011-06-01 10:11 (26 days old)
Message-ID	: <4DE6103E.6010100@hist.no>
References	: http://marc.info/?l=linux-kernel&m=130692387613423&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36702
Subject		: 2.6.39 kernel panic w/screenshots & kernel cfg link provided
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2011-05-28 12:01 (30 days old)
Message-ID	: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan>
References	: http://marc.info/?l=linux-kernel&m=130658411008127&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36662
Subject		: Intel GM45: Low resolution on external screen.
Submitter	: Alex Ferrando <alferpal@gmail.com>
Date		: 2011-06-04 17:37 (23 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36392
Subject		: 2.6.39, 3.0-rc2 Intel DRI Regression: Black Screen after trying to play video
Submitter	: Dennis Jansen <dennis.jansen@web.de>
Date		: 2011-06-01 04:41 (26 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36332
Subject		: Intel gpu turns external monitor off when X starts
Submitter	: rocko <rockorequin@hotmail.com>
Date		: 2011-05-31 02:53 (27 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36182
Subject		: Erroneous package power limit notification since kernel 2.6.39
Submitter	: Olaf Freyer <aaron667@gmx.net>
Date		: 2011-05-22 13:01 (36 days old)
Message-ID	: <4DD9092A.4080507@gmx.net>
References	: http://marc.info/?l=linux-kernel&m=130606930631131&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36092
Subject		: Filesystem lockup on USB HDD plug-in
Submitter	: Arno Wagner <arno@wagner.name>
Date		: 2011-05-28 12:34 (30 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35922
Subject		: SND_USB_AUDIO recording device not initializing correctly
Submitter	:  <bjoern.online@gmail.com>
Date		: 2011-05-26 10:30 (32 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35662
Subject		: softlockup with kernel 2.6.39
Submitter	: Hussam Al-Tayeb <ht990332@gmail.com>
Date		: 2011-05-23 08:13 (35 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35242
Subject		: NULL pointer dereference in intel_sdvo_write_cmd (was Black screen after boot)
Submitter	: Ko Mi <chaostya.test@hotmail.com>
Date		: 2011-05-17 10:27 (41 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35142
Subject		: 2.6.39-rc7-git1 boot error message (no crash)
Submitter	: werner <w.landgraf@ru.ru>
Date		: 2011-05-11 4:58 (47 days old)
Message-ID	: <web-520830057@zbackend1.aha.ru>
References	: http://marc.info/?l=linux-kernel&m=130512952706444&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34942
Subject		: [Bug] Kdump does not work when panic triggered due to MCE
Submitter	: K.Prasad <prasad@linux.vnet.ibm.com>
Date		: 2011-05-06 16:54 (52 days old)
Message-ID	: <20110506165412.GB2719@in.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=130470087226270&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35642
Subject		: On resume, I sometimes get a kernel oops with led_trigger_unregister_simple
Submitter	: Sven-Hendrik Haase <sh@lutzhaase.com>
Date		: 2011-05-23 00:15 (35 days old)
Patch		: https://bugzilla.kernel.org/attachment.cgi?id=63022


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33242
Subject		: Lockdep splat in autofs with 2.6.39-rc2
Submitter	: Nick Bowler <nbowler@elliptictech.com>
Date		: 2011-04-07 19:44 (81 days old)
Message-ID	: <20110407194403.GA29404@elliptictech.com>
References	: http://marc.info/?l=linux-kernel&m=130220545614682&w=2
Patch		: http://marc.info/?l=linux-kernel&m=130342115008659&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions introduced
between 2.6.38 and 2.6.39, unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=32012

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

