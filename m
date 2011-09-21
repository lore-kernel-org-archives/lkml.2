Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1IUPPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:15:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1IUPPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:15:32 -0400
Date: Wed, 21 Sep 2011 17:15:29 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 09/11] mm: collect LRU list heads into struct lruvec
Message-ID: <20110921151529.GH8501@tiehlicka.suse.cz>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-10-git-send-email-jweiner@redhat.com>
 <20110921134323.GE8501@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921134323.GE8501@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-09-11 15:43:23, Michal Hocko wrote:
> On Mon 12-09-11 12:57:26, Johannes Weiner wrote:
[...]
> > @@ -659,10 +658,10 @@ void lru_add_page_tail(struct zone* zone,
> >  		}
> >  		update_page_reclaim_stat(zone, page_tail, file, active);
> >  		if (likely(PageLRU(page)))
> > -			head = page->lru.prev;
> > +			__add_page_to_lru_list(zone, page_tail, lru,
> > +					       page->lru.prev);
> 
> { } around multiline __add_page_to_lru_list?

Ahh, code removed in the next patch. Sorry for noise.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
