Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab2EDTmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:42:22 -0400
Received: from d1.icnet.pl ([212.160.220.21]:56364 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab2EDTmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:42:21 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: Oleg Matcovschi <oleg.matcovschi@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] omap: dma: Clear status registers on enable/disable irq.
Date: Fri, 04 May 2012 21:39:32 +0200
Message-ID: <1633215.yCrxk1mQVq@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <20120504165146.GB5613@atomide.com>
References: <1334954578-10478-1-git-send-email-oleg.matcovschi@ti.com> <20120504165146.GB5613@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia piątek, 4 maja 2012 09:51:46 Tony Lindgren pisze:
> Hi,
> 
> * Oleg Matcovschi <oleg.matcovschi@ti.com> [120420 13:49]:
> > Use omap_disable_channel_irq() function instead of directly 
accessing CICR.
> > The omap_disable_chanel_irq() function clears pending interrupts
> > and disables interrupt on channel.
> > Functions omap2_enable_irq_lch()/omap2_disable_irq_lch() clear 
interrupt
> > status register.
> 
> This seems like a nice fix to me. As it affects all omaps, I'd like to
> see some tested-by from Janusz/Jarkko/Peter. Can you guys give it a 
try
> with some audio tests?

OK, I can do, but perhaps not before next Saturday, when I'm back home, 
able to actually listen to the audio, not only watch the IRQ counters 
rising up ;-).

Thanks,
Janusz
