Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab0HEPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:08:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48640 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0HEPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uH3MIqbPSEJSi2ajbjQd1NYSQ7jomGKtpVXVt525BC5iFcJbZsXU+FDAUgBPT6a3VW
         gMJCxOxtn359v1PKLY7hYkR3DmKEzITfljsidDU4VstumjbKyBkawLYip2m5lvwFpv3c
         c2QKK6zTmWlAEz9Colv2d8h9oesl+pJo2DNCA=
Date: Fri, 6 Aug 2010 00:08:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/7] vmscan: kill dead code in shrink_inactive_list()
Message-ID: <20100805150812.GD2985@barrios-desktop>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
 <20100805151415.31C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805151415.31C6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:14:47PM +0900, KOSAKI Motohiro wrote:
> When synchrounous lumy reclaim occur, page_list have gurantee to
> don't have active page because now page activation in shrink_page_list()
> always disable lumpy reclaim.
> 
> Then, This patch remove virtual dead code.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
