Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2GZBma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2GZBm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:42:29 -0400
Date: Wed, 25 Jul 2012 21:42:14 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix_types.h: Cleanup stale __NFDBITS and related
 definitions
Message-ID: <20120726014213.GB2356@zod.bos.redhat.com>
References: <20120725144033.GK10534@zod.bos.redhat.com>
 <1343258796.5132.164.camel@deadeye.wl.decadent.org.uk>
 <20120726012713.GA2356@zod.bos.redhat.com>
 <20120726013322.GB3532@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726013322.GB3532@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 08:33:22PM -0500, Jonathan Nieder wrote:
> Hi,
> 
> Josh Boyer wrote:
> 
> > Indeed.  However, I believe Linus pointed out that even before
> > 8b3d1cda4f5f the macros that were removed weren't actually used.
> > It's likely safe to go back further than just 3.4.
> >
> > I'll verify again in the morning and include the furthest back we could
> > remove these.  For now, let's go with what you suggest to be safe.
> 
> I may be in the minority in having this view or missing a subtlety,
> but shouldn't the question be the furthest back we need to remove
> these rather than the furthest back we could?

That should be the question, yes.  The answer is:

However far back people wish to use older stable kernel-headers to build
applications against newer glibc.

It isn't a clear answer.  Some people stick with older kernels while
they update their userspace.  I was thinking along the lines of the 3.0
kernel being the oldest I'd check for but if people think we shouldn't
bother than that's fine by me.

josh
