Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab0IGP3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:29:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37723 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab0IGP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rkaleBoXm8f585A1s0dg8jbFP88krIS+UJI7a4pmNH9xIwPP3g2a8v+4SNdF7wyI7W
         Lq+Xwdv3NqvHh4WHKuptnKzK1ZtnSsbVUGVJePVhmeA6AlDnQv4SbBF8FYdRMhUrZ8KA
         47ds+Pks7VTwqiHFlORbWvNwkZRdrmf2+bEs0=
Date: Wed, 8 Sep 2010 00:28:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use
 lock_page() instead trylock_page()
Message-ID: <20100907152840.GD4620@barrios-desktop>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-6-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283770053-18833-6-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:47:28AM +0100, Mel Gorman wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> With synchrounous lumpy reclaim, there is no reason to give up to reclaim
> pages even if page is locked. This patch uses lock_page() instead of
> trylock_page() in this case.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
