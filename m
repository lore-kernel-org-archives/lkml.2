Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1AYXe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:34:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39404 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752754Ab1AYXey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:34:54 -0500
Date: Tue, 25 Jan 2011 18:34:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, richm@oldelvet.org.uk,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [patch 1/3] introduce __u64_aligned and U64_ALIGN() for
	structure alignment in custom sections (v3)
Message-ID: <20110125233451.GA29539@Krystal>
References: <20110121203630.725922272@efficios.com> <20110121203642.725191236@efficios.com> <20110121.160503.233879710.davem@davemloft.net> <20110122171134.GA31308@Krystal> <1295718225.12215.4822.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295718225.12215.4822.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:33:23 up 63 days,  4:36,  4 users,  load average: 0.14, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2011-01-22 at 12:11 -0500, Mathieu Desnoyers wrote:
> 
> > After these patches get merged -- I would recommend going through the tracing
> > tree -- they'll have to go to -stable too. I'm therefore forwarding this to
> > stable@kernel.org (the same should be done for the two other patches in this
> > series).
> 
> Hi Mathieu,
> 
> I was in the process of putting them through my ktest.pl patch-check
> tests, but unfortunately, another bug was triggered (unrelated to these)
> and prevented me from getting them ready last night.
> 
> I'll continue on them on Monday.

Hi Steven,

Any progress on the merge process for this bugfix patch series ? The issue
seemed rather pressing last week, given that it breaks sparc64.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
