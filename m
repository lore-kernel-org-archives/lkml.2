Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0LTQiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:38:10 -0500
Received: from smtp.nokia.com ([147.243.128.24]:61206 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab0LTQiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:38:09 -0500
Subject: Re: [RFC PATCHv4 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <20101218003022.GB5941@atomide.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	 <1292321383-30200-3-git-send-email-carlos.chinea@nokia.com>
	 <20101218003022.GB5941@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 18:38:34 +0200
Message-ID: <1292863114.2529.497.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Fri, 2010-12-17 at 16:30 -0800, ext Tony Lindgren wrote:
> * Carlos Chinea <carlos.chinea@nokia.com> [101214 02:13]:
> > Introduces the OMAP SSI driver in the kernel.
> > 
> > The Synchronous Serial Interface (SSI) is a legacy version
> > of HSI. As in the case of HSI, it is mainly used to connect
> > Application engines (APE) with cellular modem engines (CMT)
> > in cellular handsets.
> > 
> > It provides a multichannel, full-duplex, multi-core communication
> > with no reference clock. The OMAP SSI block is capable of reaching
> > speeds of 110 Mbit/s.
> ...
> 
> > +static int __init ssi_init(void)
> > +{
> > +	return platform_device_register(&ssi_pdev);
> > +}
> > +subsys_initcall(ssi_init);
> 
> Is this safe to do for all omaps2+ machines?
> 

Well, I think it is safe. SSI will be only built in, if it is explicitly
configured for that specific machine. And AFAIK, at susbsys initcall
time all other initializations that the OMAP SSI driver may need, will
be already in place.

But I may missed something here ?

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

