Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0JRAtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:49:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:55844 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0JRAtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:49:47 -0400
Date: Mon, 18 Oct 2010 11:49:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
In-Reply-To: <20101017184652.GB28060@infradead.org>
Message-ID: <alpine.LRH.2.00.1010181127480.9476@tundra.namei.org>
References: <20101016065206.GO4681@dastard> <20101016192027.GA6883@infradead.org> <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com> <20101017004945.GE1614@infradead.org> <20101017054008.GA16383@elte.hu> <20101017184652.GB28060@infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010, Christoph Hellwig wrote:

> Especially as our merge requirements for security/ are a lot lower than
> for the rest of the kernel given that James is very afraid of getting
> whacked by Linux for not mering things.

I think historically you'll see that I'm not afraid of getting whacked by 
Linus.

A procedure for merging security features has been adopted by consensus, 
based on suggestions from Arjan, with the aim of preventing the literally 
endless arguments which arise from security feature discussions.  It's 
sometimes referred to as the Arjan protocol, essentially:

  If the feature correctly implements a well-defined security goal, meets 
  user needs without incurring unreasonable overheads, passes technical 
  review, and is supported by competent developers, then it is likely to 
  be merged.

If you disagree with a specific feature, you need to step up while it's 
being reviewed and make a case against it according to the above criteria.

If you disagree with the protocol, then you need to come up with a better 
one, and probably implement it yourself, to the satisfaction of all 
parties.



- James
-- 
James Morris
<jmorris@namei.org>
