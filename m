Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3AGKdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:33:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:37002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab3AGKdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:33:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="242917189"
Date: Mon, 7 Jan 2013 12:36:42 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: channing <chao.bi@intel.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, sylvain.centelles@intel.com,
        ken.k.mills@intel.com, jun.d.chen@intel.com, alan@linux.intel.com
Subject: Re: [PATCH] SPI: SSP SPI Controller driver v3
Message-ID: <20130107103642.GQ13897@intel.com>
References: <1355818296.11831.287.camel@bichao>
 <20121219095616.GV2261@intel.com>
 <CACRpkdaw7Yc0OetPWK7Cv=JsVPOs6b1Tr-=4jE5Vz4oTD6f07Q@mail.gmail.com>
 <1357545943.28451.9.camel@bichao>
 <CACRpkdZ9FctBE2zYA8xX3wgf1WOOvb-SMrXDTYDuguiLiUEwbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ9FctBE2zYA8xX3wgf1WOOvb-SMrXDTYDuguiLiUEwbw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:21:04AM +0100, Linus Walleij wrote:
> On Mon, Jan 7, 2013 at 9:05 AM, channing <chao.bi@intel.com> wrote:
> 
> > Frankly I'm currently not sure whether they share same IP.. per your reminds, I tried to find but get
> > limited info about PXA SSP's IP, from the code, looks like they have part of registers the same.
> >
> > As far as I know, spi-pxa2xx.c is specific for SSP controller of PXA2XX/PXA3XX core, right?
> 
> As pointed out by Mika it may very well be the same IP anyway. People copy/paste
> share and fork VHDL/Verilog/SystemC code just as much as they do with
> kernel code.

Yes, at least on Intel Lynxpoint it is the same IP with few additional
features. I'm about to send patches to spi-pxa2xx which enable the
Lynxpoint support shortly.
