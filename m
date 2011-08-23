Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1HWT6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:58:08 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42548 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1HWT6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:58:02 -0400
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
From: Alex Elder <aelder@sgi.com>
Reply-To: <aelder@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <xfs@oss.sgi.com>,
        <akpm@linux-foundation.org>
In-Reply-To: <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
	 <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 14:57:56 -0500
Message-ID: <1314129476.2898.28.camel@doink>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.232.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 11:46 -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 10:39 AM, Alex Elder <aelder@sgi.com> wrote:
> >
> > Linus, please pull the following XFS changes.  Their effect is to
> > remove the subdirectory structure from the XFS source hierarchy.
> > There are no functional changes to the XFS code itself.  Thanks.
> 
> Pulled.
> 
> Any plans to further sanitize the namespace?

We haven't discussed it but it's not a bad idea.

> It's kind of crazy to have filenames like
> 
>    fs/xfs/xfs_trace.c
> 
> which just duplicate the "xfs" part for no good reason. Why not just
> do something like
> 
>   for i in xfs_*; do j=$(echo $i | sed 's/^xfs_//'); git mv $i $j; done
> 
> to get rid of the silly "xfs_" prefix that adds nothing?
> 
> You could use the bytes you save to rename "qm.c" to "quota_manager.c"
> instead. Wouldn't it be nice to have *good* names, instead of a jumble
> of crazy and mostly redundant letters?

We're getting there, gradually.  The code is certainly
evolving in that direction, though that hasn't happened
in the file names.  Doing that would require my fingers
to get used to skipping over the "xfs_" spasm though...

					-Alex

