Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1FYX7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 19:59:45 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:39382 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751854Ab1FYX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 19:59:44 -0400
Date: Sun, 26 Jun 2011 09:59:39 +1000
From: CaT <cat@zip.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: boot/kernel init duration regression in 2.6.39 (was: Re: [Bug
 #12909] boot/kernel init duration regression from 2.6.28)
Message-ID: <20110625235939.GA17970@zip.com.au>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
 <AsKNxFx2juN.A.z3H.SGn2JB@chimera>
 <20090406224749.GC19377@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406224749.GC19377@zip.com.au>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 08:47:49AM +1000, CaT wrote:
> On Mon, Apr 06, 2009 at 09:05:41PM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12909
> > Subject		: boot/kernel init duration regression from 2.6.28
> > Submitter	: CaT <cat@zip.com.au>
> > Date		: 2009-03-16 10:25 (22 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123720083515950&w=4
> 
> I got it tracked down to .29-rc1. I guess I'll need to learn to use git
> now (and user the desktop - compiling on the EEE takes /ages/). Also have
> .29.1 ready to test when I get home tonight.

This bug appears to be back in .39 and .39.2. Same pause in the same section.

eeepc 901 is involved.

[    2.536287] eeepc_laptop: Eee PC Hotkey Driver
[    2.538806] eeepc_laptop: Hotkey init flags 0x41
[    3.353526] hub 2-0:1.0: hub_suspend
[    3.353557] usb usb2: bus auto-suspend
[    3.353569] usb usb2: suspend_rh
[    3.596813] usb usb5: suspend_rh (auto-stop)
[    4.020640] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input7
[    4.353541] hub 3-0:1.0: hub_suspend
[    4.353581] usb usb3: bus auto-suspend
[    4.353597] usb usb3: suspend_rh
[    4.353638] hub 4-0:1.0: hub_suspend
[    4.353655] usb usb4: bus auto-suspend
[    4.353665] usb usb4: suspend_rh
[    4.353720] usb 1-8: usb auto-suspend
[    4.506857] hub 5-0:1.0: hub_suspend
[    4.506894] usb usb5: bus auto-suspend
[    4.506911] usb usb5: suspend_rh
[    4.506957] hub 6-0:1.0: hub_suspend
[    4.506977] usb usb6: bus auto-suspend
[    6.170185] ata2: link is slow to respond, please be patient (ready=0)
[    6.366858] hub 1-0:1.0: hub_suspend
[    6.366895] usb usb1: bus auto-suspend
[    6.366911] ehci_hcd 0000:00:1d.7: suspend root hub
[    7.670579] ata2.00: CFA: ASUS-PHISON SSD, TST2.04U, max UDMA/66
[    7.673098] ata2.00: 7880544 sectors, multi 0: LBA 
[    7.680458] ata2.00: configured for UDMA/66
[    7.683267] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    7.686546] sd 1:0:0:0: [sdb] 7880544 512-byte logical blocks: (4.03 GB/3.75 GiB)
[    7.686909] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    7.692132] sd 1:0:0:0: [sdb] Write Protect is off
[    7.694745] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.694812] sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    7.700201]  sdb: sdb1 sdb2 < sdb5 > sdb3 sdb4
[    7.704471] sd 1:0:0:0: [sdb] Attached SCSI disk
[   27.999338] eeepc_laptop: TYPE (2000000) not reported by BIOS, enabling anyway
[   28.006959] eeepc_laptop: PANELPOWER (4000000) not reported by BIOS, enabling anyway
[   28.009855] eeepc_laptop: Get control methods supported: 0x6101713
[   28.015878] input: Asus EeePC extra buttons as /devices/platform/eeepc/input/input8
[   29.421681] eeepc_laptop: BIOS says wireless lan is unblocked, but the pci device is absent
[   29.424576] eeepc_laptop: skipped wireless hotplug as probably inappropriate for this model

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.dailytelegraph.com.au/news/wacky/indeed/story-e6frev20-1111118083480
