Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2HNJYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:24:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2HNJYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:24:05 -0400
Date: Tue, 14 Aug 2012 10:23:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jim Schutt <jaschut@sandia.gov>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Improve hugepage allocation success rates under
 load V3
Message-ID: <20120814092358.GJ4177@suse.de>
References: <1344520165-24419-1-git-send-email-mgorman@suse.de>
 <5023FE83.4090200@sandia.gov>
 <20120809204630.GJ12690@suse.de>
 <50243BE0.9060007@sandia.gov>
 <20120810110225.GO12690@suse.de>
 <502542C7.8050306@sandia.gov>
 <20120812202257.GA4177@suse.de>
 <50296522.2000809@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50296522.2000809@sandia.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 02:35:46PM -0600, Jim Schutt wrote:
> Hi Mel,
> 
> On 08/12/2012 02:22 PM, Mel Gorman wrote:
> 
> >
> >I went through the patch again but only found the following which is a
> >weak candidate. Still, can you retest with the following patch on top and
> >CONFIG_PROVE_LOCKING set please?
> >
> 
> I've gotten in several hours of testing on this patch with
> no issues at all, and no output from CONFIG_PROVE_LOCKING
> (I'm assuming it would show up on a serial console).  So,
> it seems to me this patch has done the trick.
> 

Super.

> CPU utilization is staying under control, and write-out rate
> is good.
> 

Even better.

> You can add my Tested-by: as you see fit.  If you work
> up any refinements and would like me to test, please
> let me know.
> 

I'll be adding your Tested-by and I'll keep you cc'd on the series. It'll
look a little different because I'm expect to adjust it slightly to match
Andrew's tree but there should be no major surprises and my expectation is
that testing a -rc kernel after it gets merged is all that is necessary. I'm
planning to backport this to -stable but it'll remain to be seen if I can
convince the relevant maintainers that it should be merged.

Thanks.

-- 
Mel Gorman
SUSE Labs
