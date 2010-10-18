Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0JRJaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:30:10 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:55246 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718Ab0JRJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:30:09 -0400
Date: Mon, 18 Oct 2010 20:29:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
        eparis@redhat.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101018092917.GJ29677@dastard>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu>
 <20101017184652.GB28060@infradead.org>
 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
 <20101018062530.GD8332@bombadil.infradead.org>
 <20101017233620.0db45dd9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017233620.0db45dd9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:36:20PM -0700, Andrew Morton wrote:
> On Mon, 18 Oct 2010 02:25:30 -0400 Kyle McMartin <kyle@mcmartin.ca> wrote:
> 
> > Subject: [PATCH] ima: allow it to be completely disabled (and default to off)
> 
> Good enough as a short-term thing I guess.
> 
> But the memory consumption which David described is plain nuttiness and
> needs to be fixed, presumably by using a more appropriate data structure
> for lookups.
> 
> However unless I missed it, nobody has yet stated that they intend to
> fix this?

I think Eric said he is going to look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
