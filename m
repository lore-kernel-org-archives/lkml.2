Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0LIXnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:43:15 -0500
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:39121 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755248Ab0LIXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:43:14 -0500
Date: Fri, 10 Dec 2010 10:42:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101209234258.GB9925@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
 <20101209081756.GE8259@dastard>
 <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:53:27PM +1100, Nick Piggin wrote:
> >> Like I said, there are infinite cleanups or improvements you can make.
> >> It does not particularly matter that they happen before or after the
> >> scaling work, except if there are classes of APIs that the new locking
> >> model can no longer support.
> >
> > We do plenty of cleanups when changing code when the result gives us
> > simpler and easier to understand code. It's a trivial change that,
> > IMO, makes the code more consistent and easier to follow.
> 
> Unrelated "cleanups" in the same patch as non trivial locking change
> is stupid.

So put it in another prepartory patch. It makes the locking changes
easier to understand...

> Necessary changes to prevent bad ugliness resulting, or preventing
> repeated steps for the particular changes, etc. of course. Killing un
> related functions no.

Ok, I get the picture. You don't want a code review, you want a
rubber stamp. Find someone else to get it from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
