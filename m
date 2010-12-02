Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0LBC40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:56:26 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40122 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab0LBC4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:56:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Dec 2010 11:50:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] Provide control over unmapped pages
Message-Id: <20101202115036.1a4a42b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101202102110.157F.A69D9226@jp.fujitsu.com>
References: <20101130142509.4f49d452.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1012010859020.2849@router.home>
	<20101202102110.157F.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Dec 2010 10:22:16 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Tue, 30 Nov 2010, Andrew Morton wrote:
> > 
> > > > +#define UNMAPPED_PAGE_RATIO 16
> > >
> > > Well.  Giving 16 a name didn't really clarify anything.  Attentive
> > > readers will want to know what this does, why 16 was chosen and what
> > > the effects of changing it will be.
> > 
> > The meaning is analoguous to the other zone reclaim ratio. But yes it
> > should be justified and defined.
> > 
> > > > Reviewed-by: Christoph Lameter <cl@linux.com>
> > >
> > > So you're OK with shoving all this flotsam into 100,000,000 cellphones?
> > > This was a pretty outrageous patchset!
> > 
> > This is a feature that has been requested over and over for years. Using
> > /proc/vm/drop_caches for fixing situations where one simply has too many
> > page cache pages is not so much fun in the long run.
> 
> I'm not against page cache limitation feature at all. But, this is
> too ugly and too destructive fast path. I hope this patch reduce negative
> impact more.
> 

And I think min_mapped_unmapped_pages is ugly. It should be
"unmapped_pagecache_limit" or some because it's for limitation feature.

Thanks,
-Kame

