Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab0J0BKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:10:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60448 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab0J0BKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:10:20 -0400
Date: Tue, 26 Oct 2010 21:10:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Benjamin Poirier <benjamin.poirier@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.235 for kernel 2.6.36
Message-ID: <20101027011018.GA28612@Krystal>
References: <20101026020544.GA26701@Krystal> <4CC779AE.1040506@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC779AE.1040506@polymtl.ca>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:07:47 up 34 days,  5:09,  4 users,  load average: 0.13, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Poirier (benjamin.poirier@polymtl.ca) wrote:
> On 25/10/10 10:05 PM, Mathieu Desnoyers wrote:
> > LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
> > producing a highly efficient full system tracing solution.  It is composed of
> > several components to allow tracing of the kernel, of userspace, trace viewing
> > and analysis and trace streaming.  LTTng is open source software. It is being
> > actively developed with the community.
> > 
> > Changelog:
> > 
> > * Remove duplicated old-napi duplicated device instrumentation.
> 
> There's a tracepoint that went MIA compared to 0.232.

Ah, yes, you are right. There has been quite a few changes in net/core/dev.c
between 2.6.35 and 2.6.36, and it has been especially messy for patch hunks.

LTTng 0.235 fixes this.

Thanks for spotting it!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
