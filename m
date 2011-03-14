Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab1CNKVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:21:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:59253 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab1CNKVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:21:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,314,1297065600"; 
   d="scan'208";a="719855979"
Date: Mon, 14 Mar 2011 11:21:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Johan Palsson <johan.palsson@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: Re: [PATCH 0/5] ab8500 gpadc fixes
Message-ID: <20110314102110.GC31153@sortiz-mobl>
References: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Mar 05, 2011 at 11:45:35AM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> I have broken Daniels patch apart, fixed the GPADC fetch
> interface as agreed with Sam, added the proper authorship of
> the calibration patch to Johan and also put a new patch from
> Karl Komierowski to fix proper charging ADC on top.
Thanks a lot, all 5 patches applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
