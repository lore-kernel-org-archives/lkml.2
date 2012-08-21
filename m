Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2HUJet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:34:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:39126 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HUJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:34:46 -0400
Date: Tue, 21 Aug 2012 11:34:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2][resend] genirq: export patches
In-Reply-To: <87wr0t5amw.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <alpine.LFD.2.02.1208211133430.2856@ionos>
References: <20120706161455.dd899154fbc8a79ee530572f@canb.auug.org.au> <CACRpkdbZddOBf0PXFJjr_aRD3TEa9hSvXjAjf3--8Ko_W0zZcg@mail.gmail.com> <w3psjd55kwl.wl%kuninori.morimoto.gx@renesas.com> <CACRpkdb=bg7fc1HEW5U2PBjs_hLDRgGUNP=O6BEJRmYfCiSWpA@mail.gmail.com>
 <87r4slg063.wl%kuninori.morimoto.gx@renesas.com> <CACRpkdYSLRiAQd3kGGv8xktAvi+YbBSe1hGqMX2y7fFXQOHPXQ@mail.gmail.com> <87fw8h4xtb.wl%kuninori.morimoto.gx@renesas.com> <874nootrqo.wl%kuninori.morimoto.gx@renesas.com>
 <87wr0t5amw.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Kuninori Morimoto wrote:
> 
> Hi all
> 
> > These are "resend" of genirq export patches.
> > 
> > Kuninori Morimoto (2):
> >       genirq: export irq_set_chip_and_handler_name()
> >       genirq: export dummy_irq_chip
> 
> get_maintainer.pl showed me that Thomas is the maintainer
> of ${LINUX}/kernel/irq/,
> but am I wrong ?
> I think there is no response for these patches.
> 
> Who can care these patches ?
> Should I resend again ?

I'll have a look. Was on vacation and travelling. Still fighting with
the mail backlog.

Thanks,

	tglx
