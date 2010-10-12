Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0JLMlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:41:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:65310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221Ab0JLMli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,320,1283756400"; 
   d="scan'208";a="335093792"
Date: Tue, 12 Oct 2010 20:41:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HWPOISON: Implement hwpoison-on-free for soft offlining
Message-ID: <20101012124135.GA15163@localhost>
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org>
 <1286402951-1881-2-git-send-email-andi@firstfloor.org>
 <20101012122647.GA14208@localhost>
 <4CB45672.7020206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB45672.7020206@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +		if (PageHWPoisonOnFree(page))
> >> +			hwpoison_page_on_free(page);
> > hwpoison_page_on_free() seems to be undefined when
> > CONFIG_HWPOISON_ON_FREE is not defined.
> 
> Yes, but I rely on the compiler never generating the call in this case 
> because
> the test is zero.
> 
> It would fail on a unoptimized build, but the kernel doesn't support 
> that anyways.

Fair enough.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> Thanks for the review.

:)

Thanks,
Fengguang
