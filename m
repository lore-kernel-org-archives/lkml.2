Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1ECOxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:53:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56645 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752757Ab1ECOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:53:04 -0400
Date: Tue, 3 May 2011 15:53:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
Message-ID: <20110503145302.GT1762@opensource.wolfsonmicro.com>
References: <20110502211123.163877033@efficios.com>
 <20110502213211.250108074@efficios.com>
 <20110503140717.GA29736@Krystal>
 <1304433457.25414.2399.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304433457.25414.2399.camel@gandalf.stny.rr.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 10:37:37AM -0400, Steven Rostedt wrote:

> BTW, next time don't Cc the world on generic patch sets like this. If
> someone is Cc'd in one of the patch sets and wonders what it is about.

OTOH it's nice for maintainers to be told about stuff like this rather
than having to find out through -next failures if they do some
incremental work in the area.

> a) You did not write your change log well enough

> b) It contains unrelated changes

> c) They could look at lkml.org to find out what this patch set is about.

> (c) is what I usually do when I'm Cc'd in a middle of a patch series.

Though in this case the combination of a and b undermined the
effectiveness of c.
