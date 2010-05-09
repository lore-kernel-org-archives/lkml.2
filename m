Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0EIV7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 17:59:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0EIV7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 17:59:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.34-rc6-git6: Reported regressions from 2.6.33
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
Message-ID: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
Date: Sun,  9 May 2010 23:13:46 +0200 (CEST)
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
  2010-05-09       80       27          24
  2010-05-04       76       26          22
  2010-04-20       64       35          34
  2010-04-07       48       35          33
  2010-03-21       15       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15951
Subject		: commit 9630bdd9 changes behavior of the poweroff
Submitter	: Michal Hocko <mhocko@suse.cz>
Date		: 2010-04-01 13:39 (39 days old)
Message-ID	: <20100401133923.GA4104@tiehlicka.suse.cz>
References	: http://marc.info/?l=linux-kernel&m=127012918316305&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15936
Subject		: Suspicious rcu_dereference_check() usage detected during 2.6.34-rc6 boot on PPC64/p5 processor
Submitter	: Subrata Modak <subrata@linux.vnet.ibm.com>
Date		: 2010-05-06 7:29 (4 days old)
Message-ID	: <1273130279.4898.5.camel@subratamodak.linux.ibm.com>
References	: http://marc.info/?l=linux-kernel&m=127313031922395&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15935
Subject		: [BUG] btrfs: report a direct-IO bug
Submitter	: liubo <liubo2009@cn.fujitsu.com>
Date		: 2010-05-06 1:47 (4 days old)
Message-ID	: <4BE21FC1.1010901@cn.fujitsu.com>
References	: http://marc.info/?l=linux-kernel&m=127311036803487&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15924
Subject		: kacpid consumes ~100% CPU, system freezes randomly
Submitter	: Jaroslav Kameník <jaroslav@kamenik.cz>
Date		: 2010-05-06 21:12 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15909
Subject		: open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
Date		: 2010-05-05 13:01 (5 days old)
Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15880
Subject		: Very bad regression from 2.6.33 as of 1600f9def
Submitter	: Alex Elsayed <eternaleye@gmail.com>
Date		: 2010-04-29 2:28 (11 days old)
Message-ID	: <loom.20100429T041908-663@post.gmane.org>
References	: http://marc.info/?l=linux-kernel&m=127250825306178&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15863
Subject		: 2.6.34-rc5-git7 (plus all patches) -- another suspicious rcu_dereference_check() usage.
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2010-04-27 0:51 (13 days old)
Message-ID	: <h2ya44ae5cd1004261751waa5cb65ei3d139cbcfa2cc5cf@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127232949104878&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15862
Subject		: 2.6.34-rc4/5: iwlagn unusable until reload
Submitter	: Nico Schottelius <nico-linux-20100427@schottelius.org>
Date		: 2010-04-27 7:49 (13 days old)
Message-ID	: <20100427074934.GB3261@ikn.schottelius.org>
References	: http://marc.info/?l=linux-kernel&m=127235784004839&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15858
Subject		: [2.6.34-rc5] bad page state copying to/from HFS+ filesystem...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2010-04-25 21:14 (15 days old)
Message-ID	: <v2k6278d2221004251414kbbcc41baw78b86120d81dce7d@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127223008621881&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
Subject		: reiserfs locking
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2010-04-15 21:02 (25 days old)
Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15788
Subject		: external usb sound card doesn't work after resume
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2010-04-15 10:16 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15717
Subject		: bluetooth oops
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-14 20:14 (57 days old)
Message-ID	: <20100314201434.GE22059@elf.ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=126859771528426&w=4
Handled-By	: Marcel Holtmann <marcel@holtmann.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15713
Subject		: hackbench regression due to commit 9dfc6e68bfe6e
Submitter	: Alex Shi <alex.shi@intel.com>
Date		: 2010-03-25 8:40 (46 days old)
First-Bad-Commit: http://git.kernel.org/linus/9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
Message-ID	: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
References	: http://marc.info/?l=linux-kernel&m=126950632920682&w=4
Handled-By	: Christoph Lameter <cl@linux-foundation.org>
		  Pekka Enberg <penberg@cs.helsinki.fi>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15712
Subject		: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-04-01 6:06 (39 days old)
Message-ID	: <20100401060624.GA1329@ucw.cz>
References	: http://marc.info/?l=linux-kernel&m=127010200817402&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15704
Subject		: [r8169] WARNING: at net/sched/sch_generic.c
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-03-31 10:21 (40 days old)
Message-ID	: <<<20100331102142.GA3294@swordfish.minsk.epam.com>>>
References	: http://marc.info/?l=linux-kernel&m=127003090406108&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15673
Subject		: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2010-03-28 11:31 (43 days old)
Message-ID	: <1269775909.5301.4.camel@localhost.localdomain>
References	: http://marc.info/?l=linux-kernel&m=126977593326800&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15671
Subject		: intel graphic card hanging (Hangcheck timer elapsed... GPU hung)
Submitter	: Norbert Preining <preining@logic.at>
Date		: 2010-03-27 16:11 (44 days old)
Message-ID	: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
References	: http://marc.info/?l=linux-kernel&m=126970883105262&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15669
Subject		: INFO: suspicious rcu_dereference_check()
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2010-03-08 1:26 (63 days old)
Message-ID	: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=126801163107713&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15664
Subject		: Graphics hang and kernel backtrace when starting Azureus with Compiz enabled
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2010-04-01 01:09 (39 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15659
Subject		: [Regresion] [2.6.34-rc1] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2010-03-25 20:04 (46 days old)
Message-ID	: <<201003252104.24965.maciej.rutecki@gmail.com>>
References	: http://marc.info/?l=linux-kernel&m=126954749618319&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15610
Subject		: fsck leads to swapper - BUG: unable to handle kernel NULL pointer dereference & panic
Submitter	: Ozgur Yuksel <ozgur.yuksel@oracle.com>
Date		: 2010-03-22 15:59 (49 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15601
Subject		: [BUG] SLOB breaks Crypto
Submitter	: michael-dev@fami-braun.de
Date		: 2010-03-15 13:39 (56 days old)
Message-ID	: <4B9E38AF.70309@fami-braun.de>
References	: http://marc.info/?l=linux-kernel&m=126866044724539&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15590
Subject		: 2.6.34-rc1: regression: ^Z no longer stops sound
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2010-03-14 7:58 (57 days old)
Message-ID	: <<20100314075831.GA13457@elf.ucw.cz>>
References	: http://marc.info/?l=linux-kernel&m=126855353122623&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2010-03-13 23:53 (58 days old)
Message-ID	: <<alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>>
References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15768
Subject		: Incorrectly calculated free blocks result in ENOSPC from writepage
Submitter	: Dmitry Monakhov <dmonakhov@openvz.org>
Date		: 2010-04-12 11:24 (28 days old)
Handled-By	: Dmitry Monakhov <dmonakhov@openvz.org>
Patch		: http://patchwork.ozlabs.org/patch/49989/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
Subject		: BUG: physmap modprobe & rmmod
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2010-04-02 20:40 (38 days old)
Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
Patch		: https://patchwork.kernel.org/patch/90497/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15505
Subject		: No more b43 wireless interface since 2.6.34-rc1
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-03-10 06:59 (61 days old)
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

