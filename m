Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1ENW3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:29:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46245 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751707Ab1ENW3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:29:42 -0400
Date: Sat, 14 May 2011 15:29:45 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant.likely@secretlab.ca
Subject: Re: [PATCHv2 5/5] TPS65911: Comparator: Add comparator driver
Message-ID: <20110514222944.GD21792@opensource.wolfsonmicro.com>
References: <A9ADABDA-9D43-44CC-92D8-113C42AA5EE0@slimlogic.co.uk>
 <20110513165931.GK8970@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513165931.GK8970@sortiz-mobl>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:59:32PM +0200, Samuel Ortiz wrote:
> On Wed, May 04, 2011 at 07:21:46PM -0500, Jorge Eduardo Candelaria wrote:

> > +config TPS65911_COMPARATOR
> > +	tristate "TPS65911 Comparator"
> > +	depends on MFD_TPS65910
> > +	help
> > +	  if you say yes here you get support for the TPS65910 comparator
> > +	  module.

> I still don't know what it compares and why I would want to enable that.

It'll be comparing two voltages - it's quite a common feature for PMICs
with auxadcs.  I think I said in one of my previous reviews that it
probably shouldn't be user visible in Kconfig as some other driver will
need to be written to call it so that driver could just select the
symbol.

> This driver really looks like it could belong to drivers/regulator.

It's measuring rather than producing.
