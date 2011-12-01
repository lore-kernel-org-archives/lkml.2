Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1LAXTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:19:33 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40182 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab1LAXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:19:32 -0500
X-Sasl-enc: 0+nhWvyzMsoWcInp9QAZblhy8YM3G20koTsph2USnmsA 1322781571
Date: Thu, 1 Dec 2011 15:17:51 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201231751.GA4961@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
 <20111201221404.GC3365@kroah.com>
 <1322780830.4699.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322780830.4699.62.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 12:07:10AM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 14:14 -0800, Greg KH wrote:
> > greg k-h
> 
> Greg, why are you merging this crap anyway? Aren't there enough tracer
> thingies around already?

I don't know, is there?

There's some reason the distros, and users, still use lttng, so I'm
guessing that it fits the needs of quite a few people.

That's why I'm merging it, if that the in-kernel stuff obsoletes lttng,
great, let me, and the distros know.

thanks,

greg k-h
