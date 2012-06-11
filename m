Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2FKNoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:44:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2FKNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:44:36 -0400
Date: Mon, 11 Jun 2012 22:44:09 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: clean up __count_immobile_pages
Message-ID: <20120611134409.GA2707@barrios>
References: <1339380442-1137-1-git-send-email-minchan@kernel.org>
 <4FD59952.7020602@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD59952.7020602@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:08:02PM +0900, Kamezawa Hiroyuki wrote:
> (2012/06/11 11:07), Minchan Kim wrote:
> >__count_immobile_pages naming is rather awkward.
> >This patch clean up the function and add comment.
> >
> >Cc: Mel Gorman<mgorman@suse.de>
> >Cc: Michal Hocko<mhocko@suse.cz>
> >Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> >Signed-off-by: Minchan Kim<minchan@kernel.org>
> 
> exchange true<->false caused by renaming ?

Exactly.

> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks, Kame.

