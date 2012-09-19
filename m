Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab2ISPaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:30:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:46879 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab2ISPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="223998221"
Date: Wed, 19 Sep 2012 17:30:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120919153011.GH28670@sortiz-mobl>
References: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
 <20120919112315.GA8138@sortiz-mobl>
 <20120919115412.GA24731@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919115412.GA24731@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Wed, Sep 19, 2012 at 01:54:12PM +0200, Thierry Reding wrote:
> > > Thierry Reding (2):
> > >   mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
> > >   pwm: Move TWL6030 PWM driver to PWM framework
> > Both patches applied now, thanks.
> 
> Thanks. Are these queued for linux-next and 3.7?
Yes. They're on my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
