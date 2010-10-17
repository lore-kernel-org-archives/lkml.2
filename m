Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0JQBJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:09:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab0JQBJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:09:33 -0400
Date: Sat, 16 Oct 2010 21:09:17 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        eparis@redhat.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017010917.GB8332@bombadil.infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017004945.GE1614@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 08:49:45PM -0400, Christoph Hellwig wrote:
> On Sat, Oct 16, 2010 at 02:10:29PM -0700, H. Peter Anvin wrote:
> > I'm confused ... what makes you think we are?  This might have been an unintentional misconfiguration...
> 
> I didn't mean to imply you enabled it intentionally.  In fact it looks
> like the inode tracking in IMA is always on once it's compiled in, which
> totally defeats the purpose of doing it's on iternal inode tracking
> instead of bloating the inode what they originally proposed.  IMA really
> needs a kernel parameter to only enabled this crap when people actually
> use it.
> 
> And whoever turned it on in Fedora needs some serious wahcking.
> 

Hey Eric, sorry to throw you under the bus, but...

1.316        (eparis   11-Aug-09): CONFIG_IMA=y

Perhaps we should stop merging crap into the kernel if it's not supposed
to be enabled. (Granted, IMA is better than 99% of the random junk
merged in a release, it actually has somewhat useful Kconfig help text,
unlike the thousands of crap drivers that get merged which provide no
hint to what obscure medieval ARM board found only on three silicon
revisions two of which were never released they were for.)

The Kconfig description sounds generally useful to me. If it's bloated
crap, how did it get merged?

Sigh.

--Kyle
