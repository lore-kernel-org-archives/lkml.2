Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1FANAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:00:42 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:14684 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752454Ab1FANAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:00:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+UWZ9dbEhUOS55fF/SPnnh
Date: Wed, 1 Jun 2011 06:00:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Message-ID: <20110601130034.GE11352@atomide.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
 <1306927051-8937-4-git-send-email-peter.ujfalusi@ti.com>
 <20110601120754.GC11352@atomide.com>
 <201106011554.53090.peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106011554.53090.peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [110601 05:50]:
> On Wednesday 01 June 2011 15:07:54 Tony Lindgren wrote:
> > 
> > Can you please take a look at creating arch/arm/mach-omap2/i2c-twl.c or
> > something in common-board-devices.c to get rid of the cut and paste
> > duplication in every board-*.c file?
> 
> Yes, it would make sense, since most of the board has similar configuration, 
> and we have lots of duplicated code around.
>  
> > Maybe you could have a generic twl_init function that allows overriding
> > things like keypad with board specific configuration?
> 
> We might need also support for overriding other configurations 
> (audio/codec/vibra for sure needs that).

Yeah, most of it might be possible to describe with just a flags
like TWL_HAS_VIBRA etc.
 
> I'll take a look, but I think it is not going to be part of v2 of this series.

We should not do renaming before the clean-up though, it gets
classified as "unnecesary churn".

Tony
