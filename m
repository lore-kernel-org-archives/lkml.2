Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0LEFOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 00:14:19 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37223 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0LEFOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 00:14:17 -0500
Date: Thu, 2 Dec 2010 12:31:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
Message-ID: <20101202070103.GP2746@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101130142509.4f49d452.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1012010859020.2849@router.home>
 <20101202102110.157F.A69D9226@jp.fujitsu.com>
 <20101202115036.1a4a42b5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101202115036.1a4a42b5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-12-02 11:50:36]:

> On Thu,  2 Dec 2010 10:22:16 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > On Tue, 30 Nov 2010, Andrew Morton wrote:
> > > 
> > > > > +#define UNMAPPED_PAGE_RATIO 16
> > > >
> > > > Well.  Giving 16 a name didn't really clarify anything.  Attentive
> > > > readers will want to know what this does, why 16 was chosen and what
> > > > the effects of changing it will be.
> > > 
> > > The meaning is analoguous to the other zone reclaim ratio. But yes it
> > > should be justified and defined.
> > > 
> > > > > Reviewed-by: Christoph Lameter <cl@linux.com>
> > > >
> > > > So you're OK with shoving all this flotsam into 100,000,000 cellphones?
> > > > This was a pretty outrageous patchset!
> > > 
> > > This is a feature that has been requested over and over for years. Using
> > > /proc/vm/drop_caches for fixing situations where one simply has too many
> > > page cache pages is not so much fun in the long run.
> > 
> > I'm not against page cache limitation feature at all. But, this is
> > too ugly and too destructive fast path. I hope this patch reduce negative
> > impact more.
> > 
> 
> And I think min_mapped_unmapped_pages is ugly. It should be
> "unmapped_pagecache_limit" or some because it's for limitation feature.
>

The feature will now be enabled with a CONFIG and boot parameter, I
find changing the naming convention now - it is already in use and
well known is not a good idea. THe name of the boot parameter can be
changed of-course. 

-- 
	Three Cheers,
	Balbir
