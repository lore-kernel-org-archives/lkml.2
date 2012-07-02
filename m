Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2GBOW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:22:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:17239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2GBOWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187518102"
Date: Mon, 2 Jul 2012 16:33:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH 7/7] mfd: s2mps11: Add samsung s2mps11 pmic
Message-ID: <20120702143343.GG22065@sortiz-mobl>
References: <067901cd4d45$a949f150$fbddd3f0$@com>
 <20120618125232.GO3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618125232.GO3974@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

On Mon, Jun 18, 2012 at 01:52:32PM +0100, Mark Brown wrote:
> On Mon, Jun 18, 2012 at 08:29:45PM +0900, Sangbeom Kim wrote:
> 
> > -struct sec_irq_data {
> > -	int reg;
> > -	int mask;
> > +static struct sec_irq_data s2mps11_irqs[] = {
> > +	[S2MPS11_IRQ_PWRONF] = {
> > +		.reg = 1,
> > +		.mask = S2MPS11_IRQ_PWRONF_MASK,
> > +	},
> 
> This looks like you should be able to factor this code out into
> regmap_irq?  Might be worth doing that first before all the renames so
> that adding the new PMIC would just be adding some more data.
Would you mind looking into that ? I'm ok with the renaming parts of this
patchset, but I think addressing Mark comment here would make the last patch
look better (and smaller).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
