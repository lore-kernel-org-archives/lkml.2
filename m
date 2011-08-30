Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1H3BuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:50:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:51489 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1H3Btu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43457494"
Subject: Re: [patch 2/2]slub: add a type for slab partial list position
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Shi, Alex" <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <alpine.DEB.2.00.1108290904130.16005@router.home>
References: <1314059823.29510.19.camel@sli10-conroe>
	 <alpine.DEB.2.00.1108231023470.21267@router.home>
	 <1314147472.29510.25.camel@sli10-conroe> <1314587187.4523.55.camel@debian>
	 <alpine.DEB.2.00.1108290904130.16005@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 09:51:55 +0800
Message-ID: <1314669116.29510.45.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 22:20 +0800, Christoph Lameter wrote:
> On Mon, 29 Aug 2011, Alex,Shi wrote:
> 
> > On Wed, 2011-08-24 at 08:57 +0800, Li, Shaohua wrote:
> > > On Tue, 2011-08-23 at 23:25 +0800, Christoph Lameter wrote:
> > > > On Tue, 23 Aug 2011, Shaohua Li wrote:
> > > >
> > > > > Adding slab to partial list head/tail is sensentive to performance.
> > > > > So adding a type to document it to avoid we get it wrong.
> > > >
> > > > I think that if you want to make it more descriptive then using the stats
> > > > values (DEACTIVATE_TO_TAIL/HEAD) would avoid having to introduce an
> > > > additional enum and it would also avoid the if statement in the stat call.
> > > ok, that's better.
> > >
> > > Subject: slub: explicitly document position of inserting slab to partial list
> > >
> > > Adding slab to partial list head/tail is sensitive to performance.
> > > So explicitly uses DEACTIVATE_TO_TAIL/DEACTIVATE_TO_HEAD to document
> > > it to avoid we get it wrong.
> >
> > Frankly speaking, using DEACTIVATE_TO_TAIL/DEACTIVATE_TO_HEAD in
> > slab_alloc, slab_free make code hard to understand. Just adding some
> > comments will be more clear and understandable. like the following:
> > Do you think so?
> 
> Yes, I like that more.
fine, let me add it to the first patch


