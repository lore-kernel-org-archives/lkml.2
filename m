Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0JKU17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:27:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36122 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab0JKU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:27:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: zz zzzzzzzzzzzzz <tempo444z@gmail.com>
Subject: Re: [Bug #19612] Computer fails to hibernate - problem idling SMP CPU's
Date: Mon, 11 Oct 2010 22:27:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera> <yeAD7A8RDxC.A.TdH.YvgsMB@chimera> <AANLkTiny4bNOQa3BB+Qxh1cFrH8LhCgY+ECE6dobL-7S@mail.gmail.com>
In-Reply-To: <AANLkTiny4bNOQa3BB+Qxh1cFrH8LhCgY+ECE6dobL-7S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010112227.11100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 11, 2010, zz zzzzzzzzzzzzz wrote:
> Test results 9-11 October 2010 file tmp.pm_test.txt
> 
> linux-source-2.6.34_2.6.34-1~experimental.2_all.deb
> 
> Devices = pm_test    fail/pass 0/10
> Platform = pm_test   fail/pass 0/10
> Processors = pm_test fail/pass 2*/10 [1][2]
> Core = pm_test       fail/pass 3/2 [3][4][5]
> [1] Long delay around 112 sec, system came back apparently fully
> operational. On next test, instant error message, I *think* related to
> access to disks, then returned to gnome scr$
> [2] Long delay around 112 sec, system came back apparently fully
> operational. Checked and found one mdadm raid5 disc degraded.
> Rebooted. Told mdadm to add the partition back into $
> * This may underestime the number of failures. If in doubt about
> success, I rebooted the system. Even so, sometime in this process one
> of my mdadm partitions got kicked from its r$
> [3] Long delay 120 sec, system restored screed, no keyboard or mouse
> activity, flashing caps lock. reset (reboot)
> [4] Long delay around 112 sec, system came back apparently fully
> operational. Checked and found one mdadm raid5 partition degraded.
> Rebooted. Told mdadm to add the partition back $
> [5] long delay around 120 sec, black screen, no keyboard, no mouse,
> reset (reboot). Checked and found two mdadm raid5 partitions degraded.
> Told mdadm to add the partitions back in$
> 
> 2.6.34.7

Does it mean the problem also happens for the 2.6.34.y kernels before
2.6.34.7?

> Processors = pm_test fail/pass 4/10 [1][2][3][4][5]
> Devices = pm_test    fail/pass 0/10
> Platform = pm_test   fail/pass 0/10
> 
> [1] Long delay around 60 sec, partial restore, keyboard active, then
> system locked up, reset (reboot) needed
> [2] Long delay around 60 sec , screen restored locked up, reset (reboot) needed
> [3] instant failure to hibernate, system operational, terminal message
> "bash: echo: write error: Input/output error"
> [4] Long delay around 60 sec, black screen locked up, flashing caps
> lock, reset (reboot) needed
> [5] 15 sec delay (normal) with message "ata1 SRST failed (errorno=-16)
> then lockup, reset (reboot) needed.
> 
> 2.6.35.1
> 
> Processors = pm_test fail/pass 3/0 [1][2][3]
> platform = pm_test   fail/pass 0/3
> 
> [1][2][3] Hard lockup after about 12 secs. Caps lock flashing, black
> screen, no keyboard response. Reset (reboot)

Thanks for the update.

Rafael
