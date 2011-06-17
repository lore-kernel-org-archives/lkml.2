Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab1FQNVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:21:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906Ab1FQNVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:21:06 -0400
From: Martin <marogge@onlinehome.de>
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
Subject: Re: Kernel panic on HT machine - maybe i915 related?
Date: Fri, 17 Jun 2011 15:20:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39.1-ck2; KDE/4.5.5; x86_64; ; )
Cc: wzab@ise.pw.edu.pl
References: <201106152224.34487.marogge@onlinehome.de> <4DF9EBD0.5020403@ise.pw.edu.pl> <201106162345.16305.marogge@onlinehome.de>
In-Reply-To: <201106162345.16305.marogge@onlinehome.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106171520.31387.marogge@onlinehome.de>
X-Provags-ID: V02:K0:wAKP1Ws4b16/BKAybggxrsQn8zQt0Q5qxKSGF5ZWlGi
 oSU6fRIU9kC7NcNL3jr+FUqgpqfAU03jZVvrREGvI7o8xSGepQ
 GvuJnyEVW7AtTlcE1mynlOsmZSD3OOmJObekKUVpegW45H+TQt
 oqn8xgJwgLRerd5J8osThaXDvHy5dC1hplX6nKv0GHoJz7pFTX
 KZYv268q03IiG7OpafJNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 23:45:16 Martin wrote:
> On Thursday 16 June 2011 13:41:04 Wojciech Zabołotny wrote:
> > W dniu 15.06.2011 22:24, Martin wrote:
> > > Same here, although my panics look different from yours. In both cases
> > > I had a lot of hardware interrupts on the stack trace but no
> > > kmemcheck. I only remembered to take a photo with my mobile phone the
> > > second time. The stack trace contains handle_*irq*, tg3, ata_bmdma,
> > > __ata_sff, i915, drm_vblank_put, intel_thermal, try_preempt, resched*,
> > > drm_vblank_put, do_invalid_op, oops_end, do_bounds, panic. The EIP is
> > > drm_vblank_put+0x13/0x50.
[...]

I managed to catch a couple of kernel panics with the vanilla 2.6.39.1 kernel 
today. Screenshots:

http://www.wupload.com/file/21411414/panic_screenshots.tar

I created a kernel bugzilla entry for the issue:

https://bugzilla.kernel.org/show_bug.cgi?id=37752

Martin
