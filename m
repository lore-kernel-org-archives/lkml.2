Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1F1GT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:19:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38177 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756404Ab1F1GR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:17:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/raTf5W3Schrs0bGQsycBx
Date: Mon, 27 Jun 2011 23:17:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: =?utf-8?B?UMOpdGVy?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: Re: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0 changes
Message-ID: <20110628061721.GY23145@atomide.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1770658.gTOGV79JgY@barack>
 <20110627101835.GI23145@atomide.com>
 <2519112.D3nfO1VTXY@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2519112.D3nfO1VTXY@barack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 07:25]:
> Hi Tony,
> 
> On Monday 27 June 2011 12:18:35 Tony Lindgren wrote:
> > * Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 02:39]:
> > 
> > > Hi Tony, Samuel,
> > > 
> > > Would you have time to take a look at this series?
> > 
> > 
> > Looks good to me. If it conflicts with what we have queued
> > in the devel-cleanup branch, I should probably queue it.
> 
> There are conflicts in mach-omap2 (quite a lot), if I apply the series on top 
> of the devel-cleanup branch.
>
> > If there are no conflicts, then Samuel can queue it.
> 
> I suppose this should then go through l-o...

OK. Assuming Samuel is fine with the patches, care to put
together a branch against devel-cleanup for me to pull?

Regards,

Tony
