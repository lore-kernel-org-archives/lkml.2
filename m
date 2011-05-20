Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab1ETBUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:20:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934603Ab1ETBUV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110520111516.784c0c9c.sfr@canb.auug.org.au>
References: <20110520111516.784c0c9c.sfr@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 May 2011 18:19:30 -0700
Message-ID: <BANLkTi=f5SxiAz-rJeb_Yh5M9W4OC+aY0g@mail.gmail.com>
Subject: Re: linux-next: build failure in Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 6:15 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> reverting commit e66eed651fd1 ("list: remove prefetching from regular
> list iterators").  This is, of course, why we like to put stuff into
> linux-next before it goes into your tree :-)

Ahhah. Another case that magically depended on <linux/list.h> silently
including half the universe thanks to <linux/prefetch.h> (which in
turn included all manner of helper headers).

> I have applied this patch for today:

Looks good, I'll take it.

                        Linus
