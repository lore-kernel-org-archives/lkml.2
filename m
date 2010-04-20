Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DTDzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:55:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0DTDz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:55:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.34-rc5: Reported regressions from 2.6.33
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
Message-ID: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
Date: Tue, 20 Apr 2010 05:15:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.33,
for which there are no fixes in the mainline known to the tracking team.
If any of them have been fixed already, please let us know.

If you know of any other unresolved regressions from 2.6.33, please let us
know either and we'll add them to the list.  Also, please let us know
if any of the entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply
to this message with CCs to the people involved in reporting and handling
the issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2010-04-20       64       35          34
  2010-04-07       48       35          33
  2010-03-21       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15812
Subject		: utsname.domainname not set in x86_32 processes (causing "YPBINDPROC_DOMAIN: domain not bound" errors)
Submitter	:  <adi@hexapodia.org>
Date		: 2010-04-19 21:28 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
Subject		: reiserfs locking
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-04-15 21:02 (5 days old)
Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15796
Subject		: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
Submitter	: Éric Piel <Eric.Piel@tremplin-utc.net>
Date		: 2010-04-13 21:54 (7 days old)
First-Bad-Commit: http://kernel.org/git/linus/7b3a177b0d4f92b3431b8dca777313a07533a710
Message-ID	: <4BC4E812.6050602@tremplin-utc.net>
References	: http://marc.info/?l=linux-kernel&m=127119569009790&w=2
Handled-By	: Takashi Iwai <tiwai@suse.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15795
Subject		: 2.6.34-rc4 : OOPS in unmap_vma
Submitter	: Parag Warudkar <parag.lkml@gmail.com>
Date		: 2010-04-14 (6 days old)
Message-ID	: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
References	: http://marc.info/?l=linux-kernel&m=127121006625429&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15790
Subject		: Meta-Bug: Regressions
Submitter	: Florian Mickler <fmickler@gmx.de>
Date		: 2010-04-15 18:21 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15788
Subject		: external usb sound card doesn't work after resume
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2010-04-15 10:16 (5 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15774
Subject		: 2.6.34-rc3: eth0 (8139too): transmit queue 0 timed out
Submitter	: Németh Márton <nm127@freemail.hu>
Date		: 2010-04-10 12:33 (10 days old)
Message-ID	: <4BC07022.6000708@freemail.hu>
References	: http://marc.info/?l=linux-kernel&m=127090287021976&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15768
Subject		: Incorrectly calculated free blocks result in ENOSPC from writepage
Submitter	: Dmitry Monakhov <dmonakhov@openvz.org>
Date		: 2010-04-12 11:24 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15744
Subject		: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2010-04-06 22:54 (14 days old)
Message-ID	: <<4BC51312.6080302@oracle.com></desc>>
References	: http://marc.info/?l=linux-kernel&m=127059449031511&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15730
Subject		: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
Submitter	: Borislav Petkov <bp@alien8.de>
Date		: 2010-04-02 17:59 (18 days old)
Message-ID	: <20100402175937.GA19690@liondog.tnic>
References	: http://marc.info/?l=linux-kernel&m=127023173329741&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
Subject		: BUG: physmap modprobe & rmmod
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-04-02 20:40 (18 days old)
Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15719
Subject		: virtio_net causing kernel BUG when running under VirtualBox
Submitter	: Thomas Müller <thomas@mathtm.de>
Date		: 2010-03-27 14:32 (24 days old)
First-Bad-Commit: http://kernel.org/git/linus/9ab86bbcf8be755256f0a5e994e0b38af6b4d399
Message-ID	: <4BAE1707.2050803@mathtm.de>
References	: http://marc.info/?l=linux-kernel&m=126970039227740&w=4
Handled-By	: Shirley Ma <mashirle@us.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15717
Subject		: bluetooth oops
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-14 20:14 (37 days old)
Message-ID	: <20100314201434.GE22059@elf.ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=126859771528426&w=4
Handled-By	: Marcel Holtmann <marcel@holtmann.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15713
Subject		: hackbench regression due to commit 9dfc6e68bfe6e
Submitter	: Alex Shi <alex.shi@intel.com>
Date		: 2010-03-25 8:40 (26 days old)
First-Bad-Commit: http://kernel.org/git/linus/9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
Message-ID	: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=126950632920682&w=4
Handled-By	: Christoph Lameter <cl@linux-foundation.org>
		  Pekka Enberg <penberg@cs.helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15712
Subject		: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-04-01 6:06 (19 days old)
Message-ID	: <20100401060624.GA1329@ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=127010200817402&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15711
Subject		: 2.6.34-rc3, BUG at mm/slab.c:2989
Submitter	: Heinz Diehl <htd@fancy-poultry.org>
Date		: 2010-04-01 17:52 (19 days old)
Message-ID	: <20100401175225.GA6581@fancy-poultry.org>
References	: http://marc.info/?l=linux-kernel&m=127014437406250&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
Subject		: [r8169] WARNING: at net/sched/sch_generic.c
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-03-31 10:21 (20 days old)
Message-ID	: <<20100331102142.GA3294@swordfish.minsk.epam.com>>
References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15698
Subject		: Freeze on power-off / suspend to ram
Submitter	: arond <hector1987@gmail.com>
Date		: 2010-04-05 13:53 (15 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-03-28 11:31 (23 days old)
Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15672
Subject		: KVM bug, git bisected
Submitter	: Kent Overstreet <kent.overstreet@gmail.com>
Date		: 2010-03-27 12:43 (24 days old)
First-Bad-Commit: http://kernel.org/git/linus/5beb49305251e5669852ed541e8e2f2f7696c53e
Message-ID	: <4BADFD74.8060904@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126969385121711&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15671
Subject		: intel graphic card hanging (Hangcheck timer elapsed... GPU hung)
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2010-03-27 16:11 (24 days old)
Message-ID	: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=126970883105262&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15669
Subject		: INFO: suspicious rcu_dereference_check()
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-03-08 1:26 (43 days old)
Message-ID	: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126801163107713&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
Subject		: start_kernel(): bug: interrupts were enabled early
Submitter	: Rabin Vincent <rabin@rab.in>
Date		: 2010-03-25 19:53 (26 days old)
First-Bad-Commit: http://kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
Message-ID	: <20100325194100.GA2364@debian>
References	: http://marc.info/?l=linux-kernel&m=126954607216519&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15664
Subject		: Graphics hang and kernel backtrace when starting Azureus with Compiz enabled
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2010-04-01 01:09 (19 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15661
Subject		: PROBLEM: crash on halt with 2.6.34-0.16.rc2.git0.fc14.x86_64
Submitter	: Jon Masters <jonathan@jonmasters.org>
Date		: 2010-03-26 15:29 (25 days old)
Message-ID	: <<1269617372.3779.234.camel@localhost>>
References	: http://marc.info/?l=linux-kernel&m=126961739803949&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15659
Subject		: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2010-03-25 20:04 (26 days old)
Message-ID	: <201003252104.24965.maciej.rutecki@gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126954749618319&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15625
Subject		: BUG: 2.6.34-rc1, RIP is (null)
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-03-18 22:22 (33 days old)
Message-ID	: <4BA2A7A9.4080503@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=126895098217351&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15611
Subject		: Failure with the 2.6.34-rc1 kernel
Submitter	: Rupjyoti Sarmah <rsarmah@amcc.com>
Date		: 2010-03-16 15:45 (35 days old)
Message-ID	: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com>
References	: http://marc.info/?l=linux-kernel&m=126875435718396&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15610
Subject		: fsck leads to swapper - BUG: unable to handle kernel NULL pointer dereference & panic
Submitter	: Ozgur Yuksel <ozgur.yuksel@oracle.com>
Date		: 2010-03-22 15:59 (29 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15601
Subject		: [BUG] SLOB breaks Crypto
Submitter	: michael-dev@fami-braun.de
Date		: 2010-03-15 13:39 (36 days old)
Message-ID	: <4B9E38AF.70309@fami-braun.de>
References	: http://marc.info/?l=linux-kernel&m=126866044724539&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15590
Subject		: 2.6.34-rc1: regression: ^Z no longer stops sound
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-14 7:58 (37 days old)
Message-ID	: <20100314075831.GA13457@elf.ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=126855353122623&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2010-03-13 23:53 (38 days old)
Message-ID	: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15553
Subject		: Screen backlight doesn't come back on after lid was closed (GM45)
Submitter	:  <bugs@kaijauch.de>
Date		: 2010-03-17 14:35 (34 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15551
Subject		: WARNING: at net/mac80211/work.c:811 ieee80211_work_work+0x7f/0xde8 [mac80211]()
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2010-03-16 22:03 (35 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15505
Subject		: No more b43 wireless interface since 2.6.34-rc1
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-03-10 06:59 (41 days old)
Handled-By	: Yinghai Lu <yinghai@kernel.org>
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=15505#c11


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.33,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=15310

Please let the tracking team know if there are any Bugzilla entries that
should be added to the list in there.

Thanks!

