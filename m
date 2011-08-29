Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1H2OVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:21:00 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:24422 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753237Ab1H2OU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:20:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bYZUePsVM1mUoI2NN4Aib1ma2R6ZpEp9nN4VGeZLlUgxC33
 EFFsOqv8psOCbckbbYe8cwSS4mgkwugkUdx3MMt7xIwyF6TQ5vTWd_9T8KlD
 7.37Bn43.QDka.m2qSoFKlzuvcq0ZTWKzkuM392k.8yIi3hw_RpjnYszUr3g
 _5GvAgsf1ewOKx6q9IptZh.ejCYSDbY3xP9BkIHFrKA21iguT9T_BGv7yHwc
 YOKIewlNpBdxxKtlS2Q5hlFiiX0MlQoOf8_OpMrZlS5ubQ_LGls61exGd0dW
 lIYkVwjEdI09a.6Ch7QyujHED5oLYi_EO09HwZLibx.75boMySqHgocSS.Un
 V4Ns.OFBCg0sMyP6n.9ce8KPUI9bStifdA9cxdv_gLGzwjA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 29 Aug 2011 09:20:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "Li, Shaohua" <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch 2/2]slub: add a type for slab partial list position
In-Reply-To: <1314587187.4523.55.camel@debian>
Message-ID: <alpine.DEB.2.00.1108290904130.16005@router.home>
References: <1314059823.29510.19.camel@sli10-conroe>  <alpine.DEB.2.00.1108231023470.21267@router.home>  <1314147472.29510.25.camel@sli10-conroe> <1314587187.4523.55.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Alex,Shi wrote:

> On Wed, 2011-08-24 at 08:57 +0800, Li, Shaohua wrote:
> > On Tue, 2011-08-23 at 23:25 +0800, Christoph Lameter wrote:
> > > On Tue, 23 Aug 2011, Shaohua Li wrote:
> > >
> > > > Adding slab to partial list head/tail is sensentive to performance.
> > > > So adding a type to document it to avoid we get it wrong.
> > >
> > > I think that if you want to make it more descriptive then using the stats
> > > values (DEACTIVATE_TO_TAIL/HEAD) would avoid having to introduce an
> > > additional enum and it would also avoid the if statement in the stat call.
> > ok, that's better.
> >
> > Subject: slub: explicitly document position of inserting slab to partial list
> >
> > Adding slab to partial list head/tail is sensitive to performance.
> > So explicitly uses DEACTIVATE_TO_TAIL/DEACTIVATE_TO_HEAD to document
> > it to avoid we get it wrong.
>
> Frankly speaking, using DEACTIVATE_TO_TAIL/DEACTIVATE_TO_HEAD in
> slab_alloc, slab_free make code hard to understand. Just adding some
> comments will be more clear and understandable. like the following:
> Do you think so?

Yes, I like that more.

Acked-by: Christoph Lameter <cl@linux.com>
