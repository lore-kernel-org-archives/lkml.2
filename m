Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1CWKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:42:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48308 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756205Ab1CWKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:42:19 -0400
Date: Wed, 23 Mar 2011 10:42:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110323104230.GA778@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
 <20110322223702.GO14675@home.goodmis.org>
 <4D892C0A.1090606@codeaurora.org>
 <1300835998.14261.13.camel@gandalf.stny.rr.com>
 <20110323000100.GB2529@opensource.wolfsonmicro.com>
 <1300840734.14261.72.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300840734.14261.72.camel@gandalf.stny.rr.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:38:54PM -0400, Steven Rostedt wrote:
> On Wed, 2011-03-23 at 00:01 +0000, Mark Brown wrote:

> > What's a mutex type?  I have to say this is the first time I've heard of
> > mutex types and the documentation in mutex.c and mutex-design.txt isn't
> > precisely verbose on what mutex_lock_nested() is for or how one would
> > pick subclass.

> Sorry, I said "mutex type" as a synonym to "lock class". A lock class is
> pretty much how a lock is defined.

OK, lock class can be grepped which was the main thing, thanks.

> There's better documentation about this in the lockdep-design.txt.

That's helpful, though it doesn't really say anything about how one
picks subclass?
