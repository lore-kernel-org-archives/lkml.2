Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab0LMFGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 00:06:07 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47293 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab0LMFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 00:06:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC82BU15LdLl/2dsb2JhbACjf3nBGoVKBA
Date: Mon, 13 Dec 2010 16:05:58 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/46] fs: dcache scale hash
Message-ID: <20101213050558.GA8624@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <3eb32695435ae6c5fd1601467d78b560b5058e2b.1290852959.git.npiggin@kernel.dk>
 <20101209060911.GB8259@dastard>
 <20101209062801.GA3749@amd>
 <20101209081756.GE8259@dastard>
 <AANLkTimF457VDRTxjjhu+J9E616LBKP_86UcNS-u+P3p@mail.gmail.com>
 <20101209234258.GB9925@dastard>
 <20101210023520.GC3331@amd>
 <20101210090126.GH8259@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210090126.GH8259@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 08:01:26PM +1100, Dave Chinner wrote:
> > I would prefer more in-depth review than from someone who doesn't know
> > d_lock protects d_flags,
> 
> Your implication about my competence is incorrect and entirely
> inappropriate.  Ad hominen attacks don't improve your argument or
> encourage other people to review your code.

I'll also just add that if you don't like ad-hominen attacks, you
shouldn't have made implications about my integrity and honesty by
accusing me of wanting a rubber stamp, rather than a real review.
Which was before I suggested that you were confused about d_flags
locking, you'll note.

