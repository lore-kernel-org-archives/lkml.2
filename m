Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1DZHeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:34:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:36500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab1DZHeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:34:18 -0400
Date: Tue, 26 Apr 2011 08:34:10 +0100
From: Mel Gorman <mgorman@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arve Hj?nnev?g <arve@android.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Check if any page in a pageblock is reserved before
 marking it MIGRATE_RESERVE
Message-ID: <20110426073410.GA4658@suse.de>
References: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1303436043-26644-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 06:34:03PM -0700, John Stultz wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> This fixes a problem where the first pageblock got marked MIGRATE_RESERVE even
> though it only had a few free pages. This in turn caused no contiguous memory
> to be reserved and frequent kswapd wakeups that emptied the caches to get more
> contiguous memory.
> 
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Mel Gorman <mgorman@suse.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> 
> [This patch was submitted and acked a little over a year ago
> (see: http://lkml.org/lkml/2010/4/6/172 ), but never seemingly
> made it upstream. Resending for comments. -jstultz]
> 
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Whoops, should have spotted it slipped through. FWIW, I'm still happy
with my Ack being stuck onto it.

Thanks.

-- 
Mel Gorman
SUSE Labs
