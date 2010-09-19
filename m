Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0ISFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 01:09:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751125Ab0ISFJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 01:09:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UsdVXNBLU6bf8l59l/4lnPjNJAYCQmkHrMNtf5M
	rYE7yDdBtvR63K
Subject: Re: [Stable-review] [064/123] sched: Protect task->cpus_allowed
 access in sched_getaffinity()
From: Mike Galbraith <efault@gmx.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <1284841948.5879.301.camel@localhost>
References: <20100918185724.290702750@clark.site>
	 <20100918185958.285024381@clark.site> <1284841948.5879.301.camel@localhost>
Content-Type: text/plain
Date: Sun, 19 Sep 2010 07:10:06 +0200
Message-Id: <1284873006.7467.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 21:32 +0100, Ben Hutchings wrote:
> I'm somewhat disturbed by the number of non-trivial scheduler changes
> here.  How well have these been tested as applied to the 2.6.32.y
> branch?

All of them of course.

	-Mike

