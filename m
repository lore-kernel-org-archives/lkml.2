Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2GPNoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:44:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:41798 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2GPNoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:44:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123007893"
Date: Mon, 16 Jul 2012 15:43:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: add tps65910 32-kHz-crystal-input init
Message-ID: <20120716134355.GI20652@sortiz-mobl>
References: <20120705152334.GH18200@sortiz-mobl>
 <1342014273-31665-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342014273-31665-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Wed, Jul 11, 2012 at 03:44:33PM +0200, Johan Hovold wrote:
> Replace tps65910_misc_init with a dedicated init function for the
> 32-kHz-crystal input.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> Hi Samuel,
> 
> How about something like this? My thought with misc_init was that it could be
> extended should more simple initialisation like for the ck32k_xtal need to be
> done, but perhaps it's cleaner to stick with dedicated init functions
> through-out. At least for now.
Yes, it's clearer, at least to me.
I applied this patch, thanks for following up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
