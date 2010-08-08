Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0HHS0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 14:26:10 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35776 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0HHS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 14:26:08 -0400
Date: Sun, 8 Aug 2010 20:25:58 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>,
        Michael Hirsch <m.hirsch@raumfeld.com>, ath5k-devel@venema.h4ckr.net
Subject: Re: wireless: Problems with ath5k and 2.6.35
Message-ID: <20100808182558.GC10432@buzzloop.caiaq.de>
References: <20100807172108.GA15974@buzzloop.caiaq.de>
 <4C5E68C1.9070403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5E68C1.9070403@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, Aug 08, 2010 at 10:20:17AM +0200, Jiri Slaby wrote:
> On 08/07/2010 07:21 PM, Daniel Mack wrote:
> > [    2.142771] ath5k 0000:00:0c.0: guessed PCI INT A -> IRQ 9
> > [    2.148319] ath5k 0000:00:0c.0: sharing IRQ 9 with 0000:00:01.2
> > [    2.154548] ath5k 0000:00:0c.0: registered as 'phy0'
> > [    3.126593] irq 9: nobody cared (try booting with the "irqpoll" option)
> > [    3.130015] Pid: 1, comm: swapper Not tainted 2.6.35+ #1
> > [    3.130015] Call Trace:
> > [    3.130015]  [<c013e984>] __report_bad_irq+0x2e/0x6f
> > [    3.130015]  [<c013eab5>] note_interrupt+0xf0/0x147
> > [    3.130015]  [<c013f076>] handle_level_irq+0x6d/0x99
> > [    3.130015]  [<c0103bf6>] handle_irq+0x1a/0x20
> > [    3.130015]  [<c0103810>] do_IRQ+0x33/0x88
> > [    3.130015]  [<c0102a69>] common_interrupt+0x29/0x30
> > [    3.130015]  [<c0120e3c>] ? __do_softirq+0x34/0xca
> > [    3.130015]  [<c0120ef7>] do_softirq+0x25/0x2a
> > [    3.130015]  [<c0120fb7>] irq_exit+0x28/0x57
> > [    3.130015]  [<c0103850>] do_IRQ+0x73/0x88
> > [    3.130015]  [<c0102a69>] common_interrupt+0x29/0x30
> > [    3.130015]  [<c013007b>] ? __async_schedule+0x38/0xe9
> > [    3.130015]  [<c013e420>] ? __setup_irq+0x1d8/0x259
> > [    3.130015]  [<c013e544>] request_threaded_irq+0xa3/0xd0
> > [    3.130015]  [<c02486e5>] ? ath5k_intr+0x0/0x28b
> > [    3.130015]  [<c032e15c>] ath5k_pci_probe+0x2f4/0x13c5
> 
> The interrupt came right after enabled in probe function with
> ATH_STAT_INVALID still set. Is this really a 2.6.34 regression? The only
> difference I see that we now (in .35) use MIB interrrupts.

I can't tell exactly when things broke, but appearantly, it worked in
2.6.31.4. I'll get back to this issue in some days when I have access to
the hardware again. I would also bisect this topic then if neccessary.


Thanks,
Daniel

