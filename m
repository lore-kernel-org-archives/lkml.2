Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1CNK04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:26:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:19049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1CNK0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:26:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,314,1297065600"; 
   d="scan'208";a="666985891"
Date: Mon, 14 Mar 2011 11:26:51 +0100
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
Message-ID: <20110314102650.GA2545@sortiz-mobl>
References: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
 <20110314102110.GC31153@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314102110.GC31153@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Mar 14, 2011 at 11:21:10AM +0100, Samuel Ortiz wrote:
> Hi Linus,
> 
> On Sat, Mar 05, 2011 at 11:45:35AM +0100, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > I have broken Daniels patch apart, fixed the GPADC fetch
> > interface as agreed with Sam, added the proper authorship of
> > the calibration patch to Johan and also put a new patch from
> > Karl Komierowski to fix proper charging ADC on top.
> Thanks a lot, all 5 patches applied now.
One more thing: I'd like to see the ab8500-gpadc.h header be renamed to
gpadc.h now that it's under the ab8500 directory. No rush, but something I'd
like to get from your next patchsets. Thanks in advance.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
