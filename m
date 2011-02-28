Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1B1KMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:12:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1B1KMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:12:01 -0500
Date: Mon, 28 Feb 2011 11:12:00 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM v4
Message-ID: <20110228101200.GF4648@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
 <1298485162.7236.4.camel@nimitz>
 <20110224134045.GA22122@tiehlicka.suse.cz>
 <20110225122522.8c4f1057.kamezawa.hiroyu@jp.fujitsu.com>
 <20110225095357.GA23241@tiehlicka.suse.cz>
 <20110228095347.7510b1d4.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228091256.GA4648@tiehlicka.suse.cz>
 <20110228182322.a34cc1fd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228095316.GC4648@tiehlicka.suse.cz>
 <20110228184821.f10dba19.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228184821.f10dba19.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-02-11 18:48:21, KAMEZAWA Hiroyuki wrote:
> On Mon, 28 Feb 2011 10:53:16 +0100
> > From e7a897a42b526620eb4afada2d036e1c9ff9e62a Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 28 Feb 2011 10:43:12 +0100
> > Subject: [PATCH] page_cgroup array is never stored on reserved pages
> > 
> > KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
> > PageReserved because we never store the array on reserved pages
> > (neither alloc_pages_exact nor vmalloc use those pages).
> > 
> > So we can replace the check by a BUG_ON.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Thank you.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
