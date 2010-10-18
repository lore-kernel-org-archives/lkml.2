Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0JRRLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:11:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0JRRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:11:01 -0400
Date: Mon, 18 Oct 2010 13:10:46 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Eric Paris <eparis@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101018171046.GE8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu>
 <20101017184652.GB28060@infradead.org>
 <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
 <20101018062530.GD8332@bombadil.infradead.org>
 <1287420534.2530.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287420534.2530.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:48:54PM -0400, Eric Paris wrote:
> I'll can address this on the fedora list, but I think this is the wrong
> approach.  IMA is supposed to be of negligible impact when not 'enabled'
> and I believe the right solution is to fix places where that isn't true.
> At the moment 3 have been identified.
> 

My beef is #2, which is what I want to see solved. If there's a million
people using Fedora, and 2 people use IMA, that's an awful lot of bytes
that could be otherwise used.

I think it should be entirely opt in, with a CONFIG_IMA_DEFAULT_ON or
something like we do for security hooks.

Anyway, If you can address #2, then I'm happy having it enabled. If it's
taken us this long to notice the impact, then it doesn't seem to be
all that large in the general case, and if it can be reduced, then that
should make everyone happy.

--Kyle
