Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1F1GvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:51:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50162 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753338Ab1F1GuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:50:18 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xDeWNB5Fr+9Xux9LDzU2W
Date: Mon, 27 Jun 2011 23:50:10 -0700
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
Subject: Re: Re: Re: [PATCH v6 00/18] MFD/ASoC/Input: TWL4030/TWL60X0
 changes
Message-ID: <20110628065010.GZ23145@atomide.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <2519112.D3nfO1VTXY@barack>
 <20110628061721.GY23145@atomide.com>
 <7290395.1hzL9xckCf@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7290395.1hzL9xckCf@barack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Péter Ujfalusi <peter.ujfalusi@ti.com> [110627 23:39]:
> Hi Tony,
> 
> On Tuesday 28 June 2011 08:17:21 Tony Lindgren wrote:
> > OK. Assuming Samuel is fine with the patches, care to put
> > together a branch against devel-cleanup for me to pull?
> 
> While waiting for Samuel, I can start preparing the branch for you, since the 
> bulk of the conflicts are in mach-omap2, should not affect the MFD parts.
> Can I add your ack to the mach-omap2 parts, or are you prefer to handle this 
> yourself?

OK here you go for the omap changes:

Acked-by: Tony Lindgren <tony@atomide.com>
