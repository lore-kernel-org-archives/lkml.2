Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0ETIeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:34:14 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:55203 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0ETIeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:34:11 -0400
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after console_init
Date: Thu, 20 May 2010 12:33:55 +0400
User-Agent: KMail/1.9.9
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com> <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com> <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005201233.56877@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I could not get dmesg output to console/serial and
> > klogd(/var/log/messages) anymore with 2.6.33-rt17 _after_ the kernel
> > boot is done(on non-RT kernel it works fine). I made below changes it
> > starts to work again, however I'm unsure how safe the change is.
> > Please advise.
>
> Well, obviously it's unsafe if you remove safety checks. And if you
> care to look at the changelog of kernel/printk.c you'll find out why.

Hmm... did a quick look and could not find anything related there.
Could you please give a pointer?
