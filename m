Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2ENMvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:51:44 -0400
Received: from d1.icnet.pl ([212.160.220.21]:55980 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2ENMvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:51:43 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Tony Lindgren <tony@atomide.com>, Oleg Matcovschi <oleg.matcovschi@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] omap: dma: Clear status registers on enable/disable irq.
Date: Mon, 14 May 2012 14:48:31 +0200
Message-ID: <5693144.pkJCBoTAMO@vclass>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <4FA69DB8.7060000@bitmer.com>
References: <1334954578-10478-1-git-send-email-oleg.matcovschi@ti.com> <1633215.yCrxk1mQVq@acer> <4FA69DB8.7060000@bitmer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 of May 2012 18:50:16 Jarkko Nikula wrote:
> On 05/04/2012 10:39 PM, Janusz Krzysztofik wrote:
> >> This seems like a nice fix to me. As it affects all omaps, I'd like to
> >> see some tested-by from Janusz/Jarkko/Peter. Can you guys give it a 
> > try
> >> with some audio tests?
> > 
> > OK, I can do, but perhaps not before next Saturday, when I'm back home, 
> > able to actually listen to the audio, not only watch the IRQ counters 
> > rising up ;-).
> > 
> Ok from omap3
> 
> Tested-by: Jarkko Nikula <jarkko.nikula@bitmer.com>

Works for me on OMAP1.

Tested-by: Janusz Krzyszofik <jkrzyszt@tis.inet.pl>

