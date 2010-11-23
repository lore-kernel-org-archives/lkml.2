Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0KWOfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:35:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab0KWOfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:35:12 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: thiago <thsalex@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: Problem with usb card
Date: Tue, 23 Nov 2010 15:35:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4CEBBF07.9090607@gmail.com>
In-Reply-To: <4CEBBF07.9090607@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011231535.55886.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. November 2010, 14:17:59 schrieb thiago:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-custom #1
> [    0.000000]  [<c0121207>] warn_on_slowpath+0x40/0x4f
> [    0.000000]  [<c02b1dfd>] _spin_unlock_irqrestore+0xd/0x10
> [    0.000000]  [<c0121897>] release_console_sem+0x186/0x19f
> [    0.000000]  [<c0121cc0>] vprintk+0x2d0/0x2fe
> [    0.000000]  [<c0372eb0>] mtrr_trim_uncached_memory+0x1a7/0x1ac
> [    0.000000]  [<c0370f64>] setup_arch+0x23d/0x418
> [    0.000000]  [<c036b5c6>] start_kernel+0x70/0x33a
> [    0.000000]  =======================
> [    0.000000] ---[ end trace ca143223eefdc828 ]---
> 
> After that message error, i lost the partition table of the my sdcard
> and all work is lost too
> 

This does look like an mtrr problem, not a USB problem.

	Regards
		Oliver
