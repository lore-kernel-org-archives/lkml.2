Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1HVNHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:07:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:61096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1HVNHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:07:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40948877"
Date: Mon, 22 Aug 2011 15:09:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Kalle Komierowski <kalle.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/ab8500-gpadc: refactor GPADC API, add raw access
Message-ID: <20110822130952.GN4607@sortiz-mobl>
References: <1312981783-19117-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312981783-19117-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Aug 10, 2011 at 03:09:43PM +0200, Linus Walleij wrote:
> From: Karl Komierowski <karl.komierowski@stericsson.com>
> 
> Refactor the GPADC interface to avoid bugs in calling code:
> 
> - ab8500_gpadc_[convert|read_raw|ad_to_voltage] clarifies
>   each functions use case, *convert wraps *read_raw, and we
>   can access raw ADC values properly.
> - Renamed gpadc function arguments from "input" to "channel" to
>   clarify use, so we don't get confused again.

Ok, thanks for the clarification.
Patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
