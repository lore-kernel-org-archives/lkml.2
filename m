Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1LAWO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:14:26 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46400 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052Ab1LAWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:14:24 -0500
X-Sasl-enc: e9UAknbNREYwQB2/+2lYDsipqA5tFSkHqYLzdrxlTewi 1322777663
Date: Thu, 1 Dec 2011 14:14:04 -0800
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201221404.GC3365@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com>
 <1322776568.4699.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322776568.4699.52.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 10:56:08PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 16:41 -0500, Mathieu Desnoyers wrote:
> > LTTng needs this symbol to prepend the current task dynamic priority
> > value to events (optional context information).
> 
> I absolutely detest exporting such stuff. It propagates the idea that
> task prio actually means something. Also, modules really shouldn't care.

Mathieu, if you don't have this information, does anything really care?

thanks,

greg k-h
