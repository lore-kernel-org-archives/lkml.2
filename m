Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab1CDOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:04:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1CDOEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:04:50 -0500
Date: Fri, 4 Mar 2011 09:04:04 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/05] use proc_dointvec_minmax to check boundaries while
 needed
Message-ID: <20110304140404.GK11359@redhat.com>
References: <20110303135819.GA2620@darkstar>
 <20110303145908.GA32154@redhat.com>
 <AANLkTi=sz7By1HaJ+HhFaQDWyUnrR5PNyAcL0uPnEt-K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=sz7By1HaJ+HhFaQDWyUnrR5PNyAcL0uPnEt-K@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 09:41:59AM +0800, Dave Young wrote:
> On Thu, Mar 3, 2011 at 10:59 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Thu, Mar 03, 2011 at 09:58:20PM +0800, Dave Young wrote:
> >> proc_dointvec doesn't check extra minmax params, use proc_dointvec_minmax
> >> instead of proc_dointvec for cases need boundaries check.
> >
> > Is this patch needed, if you are basically changing it again in patches 3
> > and 5?
> 
> Sure if 3 and 5 is acked, if someone object them then this is good?

Ok.  I guess I would have posted patches 2-4 first to get everyone's
opinion.  Then if the reaction was negative, try with patch 1.

Personally I don't see any problems with patches 2-4.  Then again I don't
deal with sysctl that much, so I don't what rules there are in that area of
code.

Cheers,
Don
