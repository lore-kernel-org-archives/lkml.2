Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2D1Iug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:50:36 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:53646 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2D1Iub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:50:31 -0400
Date: Sat, 28 Apr 2012 10:50:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and
	-mfentry?
Message-ID: <20120428085028.GA6507@merkur.ravnborg.org>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com> <20120428083603.GJ27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428083603.GJ27374@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I just measured and a null compile (nothing changes) of a current
> tree calls "gcc" 141 times.
Something is wrong then which must be fixed.
There are 55 uses of cc-option in */x86/*
And only 7 uses of cc-option in the top-level Makefile.

So it looks like we evalute the same assignmet twice or more.

	Sam
