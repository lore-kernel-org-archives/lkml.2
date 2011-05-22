Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1EVUlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:41:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:22592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1EVUlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:41:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,253,1304319600"; 
   d="scan'208";a="6425334"
Date: Sun, 22 May 2011 22:40:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver
Message-ID: <20110522204056.GH18610@sortiz-mobl>
References: <A9ADABDA-9D43-44CC-92D8-113C42AA5EE0@slimlogic.co.uk>
 <20110513165931.GK8970@sortiz-mobl>
 <20110514222944.GD21792@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514222944.GD21792@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 03:29:45PM -0700, Mark Brown wrote:
> On Fri, May 13, 2011 at 06:59:32PM +0200, Samuel Ortiz wrote:
> > On Wed, May 04, 2011 at 07:21:46PM -0500, Jorge Eduardo Candelaria wrote:
> 
> > > +config TPS65911_COMPARATOR
> > > +	tristate "TPS65911 Comparator"
> > > +	depends on MFD_TPS65910
> > > +	help
> > > +	  if you say yes here you get support for the TPS65910 comparator
> > > +	  module.
> 
> > I still don't know what it compares and why I would want to enable that.
> 
> It'll be comparing two voltages - it's quite a common feature for PMICs
> with auxadcs.  I think I said in one of my previous reviews that it
> probably shouldn't be user visible in Kconfig as some other driver will
> need to be written to call it so that driver could just select the
> symbol.
> 
> > This driver really looks like it could belong to drivers/regulator.
> 
> It's measuring rather than producing.
Sure, but I still don't see how it belongs to drivers/mfd/.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
