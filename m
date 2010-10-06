Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab0JFW7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:59:36 -0400
Received: from www.tglx.de ([62.245.132.106]:36259 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab0JFW7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:59:35 -0400
Date: Thu, 7 Oct 2010 00:59:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grazvydas Ignotas <notasas@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: twl4030 irq crashes
In-Reply-To: <AANLkTik0q3i9SkydhJFbousVrHbc+eMM2SkaxR4MD41U@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010070058220.17015@localhost6.localdomain6>
References: <AANLkTik0q3i9SkydhJFbousVrHbc+eMM2SkaxR4MD41U@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Grazvydas Ignotas wrote:

> Hello,
> 
> I've pulled today's (20101006) linux-next and twl4030 started crashing
> on certain interrupts. twl4030 irq code hasn't changed so it's
> probably genirq's fault:
> 
> [    0.889739] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [    0.898193] pgd = c0004000
> [    0.901000] [00000000] *pgd=00000000
> [    0.904754] Internal error: Oops: 80000005 [#1]
> [    0.909484] last sysfs file:
> [    0.912567] Modules linked in:
> [    0.915771] CPU: 0    Not tainted
> (2.6.36-rc6-next-20101006-00001-g766a681-dirty #205)
> [    0.924133] PC is at 0x0
> [    0.926788] LR is at handle_edge_irq+0x84/0x14c

Can you please decode that line with 

addr2line -e vmlinux c0077244

Thanks,

	tglx
