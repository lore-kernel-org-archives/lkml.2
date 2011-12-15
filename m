Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab1LOWeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:34:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:19406 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1LOWeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:34:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="47709636"
Date: Thu, 15 Dec 2011 23:38:37 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/db8500-prcmu: remove support for early silicon
 revisions
Message-ID: <20111215223835.GD24898@sortiz-mobl>
References: <1323987703-27525-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323987703-27525-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

On Thu, Dec 15, 2011 at 11:21:43PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The DB8500 ED (Early Drop) and V1 are only available inside of
> ST-Ericsson or partners, we have actively replaced and scrapped
> these prototypes. All Nova products on the open market (such as
> the Snowball board) are based on V2 and later ASIC variants.
> So let us focus on supporting the silicon that will be used and
> delete this to get a clear overview.
> 
> Cc: Samuel Ortiz <samuel.ortiz@intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Sam if this is OK with you I'd prefer to take this one patch
> through the ux500 tree since it depends on other changes there
> so your ACK would be appreciated!
Sure, that one looks fine to me:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

