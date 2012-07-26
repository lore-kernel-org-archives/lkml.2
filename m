Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2GZDeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:34:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50811 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GZDeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:34:06 -0400
Date: Wed, 25 Jul 2012 22:34:01 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: Cleanup stale __NFDBITS and related
 definitions
Message-ID: <20120726033401.GB2923@burratino>
References: <20120725144033.GK10534@zod.bos.redhat.com>
 <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
 <20120726012713.GA2356@zod.bos.redhat.com>
 <20120726013322.GB3532@burratino>
 <20120726014213.GB2356@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726014213.GB2356@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:

> That should be the question, yes.  The answer is:
>
> However far back people wish to use older stable kernel-headers to build
> applications against newer glibc.
>
> It isn't a clear answer.

Thanks for explaining.

>                           Some people stick with older kernels while
> they update their userspace.  I was thinking along the lines of the 3.0
> kernel being the oldest I'd check for but if people think we shouldn't
> bother than that's fine by me.

Based on your explanation, I think 3.0 makes sense, while older
kernels like 2.6.32 are less likely to benefit.  Even when you are
stuck with an old kernel, it is possible to use newer kernel headers.

Thanks,
Jonathan
