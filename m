Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2DZVNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:13:53 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:45576 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2DZVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:13:51 -0400
Message-ID: <1335474828.2136.15.camel@shrek.rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for
 hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Fri, 27 Apr 2012 07:13:48 +1000
In-Reply-To: <201204262200.32663.rjw@sisk.pl>
References: <1334267969.2573.14.camel@shrek.rexursive.com>
	 <201204250012.00544.rjw@sisk.pl>
	 <1335410904.2136.9.camel@shrek.rexursive.com>
	 <201204262200.32663.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 22:00 +0200, Rafael J. Wysocki wrote:

> No, I didn't requested that.  There's nothing like stable-only patches,
> we only backport mainline commits to -stable.

Yeah, you told me that my patch was not straightforward, so I broke off
part of it for -stable that would fix just the most critical problem.

> > This patch should go to linux-next:
> > 
> > http://marc.info/?l=linux-kernel&m=133426808115262&w=2
> 
> OK
> 
> So I'll include it into my v3.5 push and I don't want to hear about how
> urgent it is any more.  Is that clear enough?

Look, I created a problem on some people's computer in 3.2. I feel
responsible for fixing it. I do not want their computers to hang because
of something I wrote, especially if there is a fix.

So, if I will say one more time. This patch is a fix for a regression,
caused by me, since 3.2. Please ask -stable maintainers to include it in
version in 3.2 and above.

If you want me to create a set of patches instead and then you backport
just one, let me know. I will do whatever is necessary to fix this
regression.

-- 
Bojan

