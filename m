Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2BUVLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:11:55 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57276 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753762Ab2BUVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:11:53 -0500
Date: Tue, 21 Feb 2012 16:11:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
	+ docs
Message-ID: <20120221211145.GA15210@Krystal>
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329856745.25686.72.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:10:05 up 455 days,  2:13,  6 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2012-02-21 at 15:20 -0500, Jason Baron wrote:
> 
> > I'm not really too hung up on the naming, but I did think that
> > very_[un]likely were an interesting possibility.
> 
> The problem comes from what Peter said. They are too similar to
> "likely()" and "unlikely()", and can become confusing.
> 
> Maybe "static_likely()" and "static_unlikely()" as the word "static" can
> imply something strange about these. Or perhaps a "const_likely()"?

My 2 cents:

static_likely()/static_unlikely() seems to be the less strange
construct names I've seen fly so far. ;-) And they seem to convey the
semantic of static branches and branch "hint" quite well.

Thanks,

Mathieu

> 
> Maybe "dynamic_branch_true()" and "dynamic_branch_false()". This may be
> the most descriptive.
> 
> -- Steve
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
