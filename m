Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2BTLNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:13:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:37427 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab2BTLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:13:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108595501"
Date: Mon, 20 Feb 2012 12:20:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        michael@thalmeier.at
Subject: Re: [PATCH] input/mc13783-ts: add pdata to set conversion delay
Message-ID: <20120220112014.GA4217@sortiz-mobl>
References: <1326269903-22180-1-git-send-email-michael.thalmeier@hale.at>
 <20120220111326.GR5387@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220111326.GR5387@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 12:13:26PM +0100, Samuel Ortiz wrote:
> Hi Michael,
> 
> On Wed, Jan 11, 2012 at 09:18:23AM +0100, Michael Thalmeier wrote:
> > MC13783 can be programmed to wait some clock cycles between the touch screen
> > polarization and the resistance conversion. This is needed to adjust for
> > touchscreens with high capacitance between plates.
> I applied (manually) this one to my for-next branch, thanks.
I actually applied v3.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
