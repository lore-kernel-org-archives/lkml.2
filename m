Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab1DYNls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145Ab1DYNlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:41:47 -0400
Date: Mon, 25 Apr 2011 09:41:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
Message-ID: <20110425134126.GB20887@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
 <1303398203-2918-5-git-send-email-dzickus@redhat.com>
 <20110422081838.GA24011@elte.hu>
 <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>
 <1303462476.2035.215.camel@laptop>
 <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com>
 <1303465546.2035.224.camel@laptop>
 <4DB19B80.5000900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB19B80.5000900@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 07:15:12PM +0400, Cyrill Gorcunov wrote:
> On 04/22/2011 01:45 PM, Peter Zijlstra wrote:
> ...
> > 
> > Right, so the idea is that one event (concept) has two (or more)
> > representations in the config space. And when scheduling the events we
> > find we have a conflict, we simply try the alternative encoding(s).
> > 
> ...
> 
>   Yeah, Peter, I think it's quite possible to use alternative encoding for p4 as well,
> not sure tho if some "generalized" approach for all perf would be applied to p4 but
> we can make event "aliases" being per-pmu eventually.
> 
>   So Ingo, drop this patch then ;)

Eek, when can you have an alternate patch for this Cyril?  I just want to
make sure this can still eventually find its way into 2.6.40.

Cheers,
Don
