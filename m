Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2ALVjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:39:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2ALVjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:39:16 -0500
Date: Thu, 12 Jan 2012 22:39:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: __count_immobile_pages make sure the node is online
Message-ID: <20120112213913.GC10389@tiehlicka.suse.cz>
References: <20120111084802.GA16466@tiehlicka.suse.cz>
 <20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112082722.GB1042@tiehlicka.suse.cz>
 <20120112173536.db529713.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112092314.GC1042@tiehlicka.suse.cz>
 <20120112183323.1bb62f4d.kamezawa.hiroyu@jp.fujitsu.com>
 <20120112100521.GD1042@tiehlicka.suse.cz>
 <20120112111415.GH4118@suse.de>
 <20120112123555.GF1042@tiehlicka.suse.cz>
 <20120112132629.345e0e37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120112132629.345e0e37.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-01-12 13:26:29, Andrew Morton wrote:
> On Thu, 12 Jan 2012 13:35:55 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Thu 12-01-12 11:14:15, Mel Gorman wrote:
> > > On Thu, Jan 12, 2012 at 11:05:21AM +0100, Michal Hocko wrote:
> > 
> > > Be aware that this is not the version picked up by Andrew. It would
> > > not hurt to resend as V2 with a changelog and a note saying it replaces
> > > mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch in mmotm.
> 
> They're rather different things? According to the changelogs,
> mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch fixes a
> known-to-occur oops. 
> mm-__count_immobile_pages-make-sure-the-node-is-online.patch fixes a
> bug which might happen in the future if we change the node_zones layut?

Yes, and that's the reason why I posted it as a separate patch. I could
also have squashed both patches together and it would work the same way
but I think that the zone issue wouldn't be that obvious.

> 
> So I'm thinking that
> mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch is 3.3 and
> -stable material, whereas this patch
> (mm-__count_immobile_pages-make-sure-the-node-is-online.patch) is 3.3
> material.  (Actually, it's 3.4 material which I shall stuff into 3.3
> because the amount of MM material which we're putting into 3.3 is just
> off the charts and I fear that 3.4 will be similar)

Agreed

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
