Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1AFSiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:38:06 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48836 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855Ab1AFSiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:38:04 -0500
Date: Thu, 6 Jan 2011 13:38:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        nhorman@tuxdriver.com, zhaolei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] trace event skb remove duplicate null-pointer check
Message-ID: <20110106183802.GA2335@Krystal>
References: <20110106175319.GA30610@Krystal> <20110106.101544.193712005.davem@davemloft.net> <20110106181726.GF2308@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106181726.GF2308@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:34:25 up 43 days, 23:37,  5 users,  load average: 0.10, 0.19,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Thu, Jan 06, 2011 at 10:15:44AM -0800, David Miller wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Date: Thu, 6 Jan 2011 12:53:19 -0500
> > 
> > > The check for NULL skb in the kfree_skb trace event is a duplicate from the
> > > check already done in its only caller, kfree_skb(). Remove this duplicate check.
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> May be you want to take that on the net tree? Looks like more appropriate.
> Of course this can go through the tracing tree as well.

It might be easier to manage the TRACE_EVENT() reshaping (removal of semicolumn,
tp_assign, etc) I am preparing if, at this stage, we merge most of the
include/trace/event patches through a single tree (the tracing tree). Otherwise
we might end up with more commit cross-dependencies between the trees, and
increase the risk of conflicts.

Thanks,

Mathieu

> 
> Thanks.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
