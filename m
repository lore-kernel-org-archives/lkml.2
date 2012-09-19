Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2ISAZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:38414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab2ISAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,446,1344236400"; 
   d="scan'208";a="223736707"
Date: Wed, 19 Sep 2012 02:24:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120919002459.GC3647@sortiz-mobl>
References: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, Sep 10, 2012 at 02:10:18PM +0200, Thierry Reding wrote:
> Hi,
> 
> This mini series replaces the twl_has_*() macros by the equivalent
> standard IS_ENABLED() macro and moves the PWM driver to the PWM
> framework.
> 
> I'll take the second patch through the PWM tree but would like to have
> some Acked-bys from people that know and have the hardware and can
> verify that I haven't broken anything.
We're already going to have conflicts for twl-core.c as Tony is pushing some
code for it through his tree. So, would you be ok with me carrying the whole
series through the MFD tree ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
