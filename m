Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0JQSrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:47:10 -0400
Received: from canuck.infradead.org ([134.117.69.58]:41724 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0JQSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:47:08 -0400
Date: Sun, 17 Oct 2010 14:46:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017184652.GB28060@infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017054008.GA16383@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017054008.GA16383@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 07:40:08AM +0200, Ingo Molnar wrote:
> This security feature was merged upstream last year, it's not in 
> drivers/staging/ and the Kconfig help text does not contain any warning 
> that this is 'crap', so how were the Fedora people supposed to know?

By looking at what they turn on?  What happened to the good old idea
of actually auditing what you turn on?  It might be a bit too much
for every little driver, aven if that was helpful, but for security/
code with intricate hooks all over the kernel I think it is in order.

Especially as our merge requirements for security/ are a lot lower than
for the rest of the kernel given that James is very afraid of getting
whacked by Linux for not mering things.

> Fact is that Kyle did Linux a _favor_ by enabling the feature in Fedora, 
> as it allowed the bug/inefficiency/crap to be found by Dave. Linux got 
> richer as a result as we learned about a bug that affects many people. 
> Your gratuitous insults against him are highly misguided.

I think you need to tune down your insult filter a bit :)

