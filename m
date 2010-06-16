Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0FPIWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:22:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:46836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab0FPIWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:22:09 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: roma1390 <roma1390@gmail.com>
Subject: Re: INFO: task khubd:271 blocked for more than 120 seconds.
Date: Wed, 16 Jun 2010 10:22:32 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <4C18855E.5010508@gmail.com>
In-Reply-To: <4C18855E.5010508@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161022.32398.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. Juni 2010 10:03:42 schrieb roma1390:
> Hello,
> 
> 
> We got this on our production system. Kernel: 2.6.26-2-amd64.
> This seems to be related with http://bugzilla.kernel.org/show_bug.cgi?id=13316 and still is open. Sadly to have such long standing bugs in common used subsystems like USB.
> 
> Jun 15 06:25:01 accelerator57 kernel: imklog 3.18.6, log source = /proc/kmsg started.
> Jun 16 00:36:55 accelerator57 kernel: [600606.885265] usb 6-1: USB disconnect, address 3
> Jun 16 00:39:02 accelerator57 kernel: [600738.152638] INFO: task khubd:271 blocked for more than 120 seconds.
> Jun 16 00:39:02 accelerator57 kernel: [600738.152682] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jun 16 00:39:02 accelerator57 kernel: [600738.155993] khubd         D ffff810916ca1400     0   271      2
> Jun 16 00:39:02 accelerator57 kernel: [600738.156038]  ffff810919523d50 0000000000000046 363030365b3e363c 36323538382e3630
> Jun 16 00:39:02 accelerator57 kernel: [600738.156118]  ffff810919521470 ffff810916dad220 ffff8109195216f8 00000000a00745a2
> Jun 16 00:39:02 accelerator57 kernel: [600738.156197]  ffff810919523da4 ffff810916ca1600 0000000000000286 ffff8109148851c0
> Jun 16 00:39:02 accelerator57 kernel: [600738.156245] Call Trace:
> Jun 16 00:39:02 accelerator57 kernel: [600738.156308]  [<ffffffff8039035a>] usb_kill_urb+0xa8/0xdb
> Jun 16 00:39:02 accelerator57 kernel: [600738.156612]  [<ffffffff80246111>] autoremove_wake_function+0x0/0x2e
> Jun 16 00:39:02 accelerator57 kernel: [600738.156660]  [<ffffffff8038fa32>] usb_hcd_flush_endpoint+0xd4/0xeb
> Jun 16 00:39:02 accelerator57 kernel: [600738.156707]  [<ffffffff80390a8e>] usb_disable_endpoint+0x5b/0x6d
> Jun 16 00:39:02 accelerator57 kernel: [600738.156752]  [<ffffffff80390ac5>] usb_disable_device+0x25/0xe8
> Jun 16 00:39:02 accelerator57 kernel: [600738.156792]  [<ffffffff8038c9cd>] usb_disconnect+0x92/0x142
> Jun 16 00:39:02 accelerator57 kernel: [600738.156830]  [<ffffffff8038dc07>] hub_thread+0x3f9/0xcfd
> Jun 16 00:39:02 accelerator57 kernel: [600738.156868]  [<ffffffff80246111>] autoremove_wake_function+0x0/0x2e
> Jun 16 00:39:02 accelerator57 kernel: [600738.156910]  [<ffffffff8038d80e>] hub_thread+0x0/0xcfd
> Jun 16 00:39:02 accelerator57 kernel: [600738.156952]  [<ffffffff80245feb>] kthread+0x47/0x74
> Jun 16 00:39:02 accelerator57 kernel: [600738.156993]  [<ffffffff8023008d>] schedule_tail+0x27/0x5c
> Jun 16 00:39:02 accelerator57 kernel: [600738.157036]  [<ffffffff8020cf38>] child_rip+0xa/0x12
> Jun 16 00:39:02 accelerator57 kernel: [600738.157077]  [<ffffffff80245fa4>] kthread+0x0/0x74
> Jun 16 00:39:02 accelerator57 kernel: [600738.157116]  [<ffffffff8020cf2e>] child_rip+0x0/0x12
> Jun 16 00:39:02 accelerator57 kernel: [600738.157154]

Under which conditions did you get this? Physical unplug, S3 or S4?

	Regards
		Oliver
