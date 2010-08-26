Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0HZRXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:23:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44278 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0HZRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S4rh0nE1/vtQHvSOmnlV5VrRemWLrf5VV8JTeZ5Ul8glJbnp5lyjWFjswkf4oMpzt9
         Zc5cmp1GLyaGA0zxOxs2/6jW4LLeZt3r/nB8LaZzIbHzpU2yVq+nUVyrkXKB9LNqNb6e
         L2ga/zVHsbv1ehF1IenR8JOT+qIYsJ59adKNk=
Date: Fri, 27 Aug 2010 02:23:38 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: Account for time spent congestion_waited
Message-ID: <20100826172338.GB6873@barrios-desktop>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-2-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:14PM +0100, Mel Gorman wrote:
> There is strong evidence to indicate a lot of time is being spent in
> congestion_wait(), some of it unnecessarily. This patch adds a
> tracepoint for congestion_wait to record when congestion_wait() occurred
> and how long was spent.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I think that's enough to add tracepoint until solving this issue at least.

-- 
Kind regards,
Minchan Kim
