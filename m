Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1FMOtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:49:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1FMOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QEIoafyFoEHyizaCBt4Wpmx44T4d5KMMio5BtAyXqdHEoJkF6b9YX1PaAs/5ua5SZx
         cXIpxC/JpOGxUl9LERavn0ZMomDCm+Kt0/DNMBDkpaPGkywMQxG63j33TyqPfQWEvGeD
         89ak/+XoBLHpIBKqdDXIevz3CskooJnpn/97Q=
Date: Mon, 13 Jun 2011 23:48:53 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 01/10] compaction: trivial clean up acct_isolated
Message-ID: <20110613144853.GA1414@barrios-desktop>
References: <cover.1307455422.git.minchan.kim@gmail.com>
 <71a79768ff8ef356db09493dbb5d6c390e176e0d.1307455422.git.minchan.kim@gmail.com>
 <20110612142257.GA24323@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612142257.GA24323@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 04:24:05PM +0200, Michal Hocko wrote:
> On Tue 07-06-11 23:38:14, Minchan Kim wrote:
> > acct_isolated of compaction uses page_lru_base_type which returns only
> > base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
> > In addtion, cc->nr_[anon|file] is used in only acct_isolated so it doesn't have
> > fields in conpact_control.
> > This patch removes fields from compact_control and makes clear function of
> > acct_issolated which counts the number of anon|file pages isolated.
> > 
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Sorry for the late reply. I have looked at the previous posting but

No problem. Thanks for the review, Michal.

> didn't have time to comment on it.
> 
> Yes, stack usage reduction makes sense and the function also looks more
> compact.
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 

-- 
Kind regards,
Minchan Kim
