Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0JAToR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:44:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38157 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750822Ab0JAToQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:44:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18DSL9UxXsDRBoj+kDLLvAZn/Kk0Nw3Xncad3Pc6B
	OxuSg5ixkFHtmm
Subject: Re: [PATCH] fix 2.6.32.23 suspend regression caused by commit
 6f6198a
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: stable <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101001191611.GA5259@kroah.com>
References: <1285907236.7425.42.camel@marge.simson.net>
	 <1285909451.7425.49.camel@marge.simson.net>
	 <20101001191611.GA5259@kroah.com>
Content-Type: text/plain
Date: Fri, 01 Oct 2010 21:44:11 +0200
Message-Id: <1285962251.9020.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 12:16 -0700, Greg KH wrote:
> On Fri, Oct 01, 2010 at 07:04:11AM +0200, Mike Galbraith wrote:
> > Again, with a less bouncy address.
> > 
> > From: Mike Galbraith <efault@gmx.de>
> > Date: Fri, 1 Oct 2010 05:57:59 +0200
> > Subject: [PATCH] fix 2.6.32.23 suspend regression caused by commit
> > 6f6198a
> > 
> > 6f6198a sched: kill migration thread in CPU_POST_DEAD instead of
> > CPU_DEAD
> > leaves migration threads lying about.  Mask out CPU_TASKS_FROZEN.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> Is this patch upstream already?  If so, what's the git commit id of it?
> If not, why isn't it also needed there?

No, it's not upstream, and will never go upstream because they don't
need it.  It's only needed for -stable because the fix incorporated in
-stable is incomplete.  Upstream already does what this patch adds.

	-Mike

