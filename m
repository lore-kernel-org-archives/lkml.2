Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1FAQXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:23:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21284 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab1FAQXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:23:39 -0400
MIME-Version: 1.0
Message-ID: <dedd3fa5-5dc3-4ce1-9ab4-dc77e23a6d7d@default>
Date: Wed, 1 Jun 2011 09:22:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: next phase of tmem into linux-next
References: <80f7ab04-7ae6-48cb-b254-e99343147bf0@default
 20110601142544.62494a52.sfr@canb.auug.org.au>
In-Reply-To: <20110601142544.62494a52.sfr@canb.auug.org.au>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DE66788.0080:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 31 May 2011 17:49:21 -0700 (PDT) Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> >
> > Please re-include the following tree into linux-next.  The
> > commit series is for frontswap, the complement of cleancache
> > handling swap pages, which is the next phase in tmem.  It also
> > includes the shim code to Xen tmem for frontswap.  It applies
> > cleanly on linux-3.0-rc1, but if there are any problems or
> > you have any questions, please let me know!
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git#linux-next
> 
> I don't remove trees from linux-next unless excplictly asked to, so
> this
> tree is still included

Hi Stephen --

OK, I see "Already up-to-date" in merge.log.  I'll assume
that the new frontswap commits will lag a day.  (Thanks,
Konrad, for helping me find this info and pointing out the
probable lag.)

(A thought... perhaps the merge.log generation script should
do a "date" at the beginning and end, so one knows if one
has just missed your merge window?)

> As long as you stick to the rules (posted,
> reviewed, ready for Linus), anything you add to that tree will be
> included.

Yep, understood.  Frontswap has been posted on lkml and tested for
over a year (and for nearly 2-1/2 years if counting earlier
versions as part of the original tmem postings), but hasn't gotten
as much attention because it was serialized behind merging of cleancache.

> The tree is still called "cleancache" in linux-next.  Should I change
> that to something more generic?

Yes please.  A good short name would be "tmem", but if you want
something longer and more descriptive maybe, "transcendent_memory".
I expect in the future that this might be the path for, for
example, tmem-related code that is promoted from drivers/staging.
E.g., the generic tmem.c code in drivers/staging/zcache could
probably end up in lib at some point if/when there are multiple users.

Thanks!
Dan
