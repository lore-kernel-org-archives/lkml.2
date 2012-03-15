Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031237Ab2COAGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031223Ab2COAGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:06:19 -0400
Date: Wed, 14 Mar 2012 17:06:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] radix-tree: iterating general cleanup
Message-Id: <20120314170618.ae51230b.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1203141210290.3870@eggly.anvils>
References: <20120207074905.29797.60353.stgit@zurg>
	<20120314073629.GA17016@infradead.org>
	<4F604D81.1060607@openvz.org>
	<20120314075109.GA32717@infradead.org>
	<alpine.LSU.2.00.1203141210290.3870@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 12:36:11 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> On Wed, 14 Mar 2012, Christoph Hellwig wrote:
> > On Wed, Mar 14, 2012 at 11:49:21AM +0400, Konstantin Khlebnikov wrote:
> > > Christoph Hellwig wrote:
> > > >Any updates on this series?

Linus took an interest, so I went to sleep.  It seems that a role
reversal is in order ;)

> > > I had sent "[PATCH v2 0/3] radix-tree: general iterator" February 10, there is no more updates after that.
> > > I just checked v2 on top "next-20120314" -- looks like all ok.
> > 
> > this was more a question to the MM maintainers if this is getting
> > merged or if there were any further comments.
> 
> I haven't studied the code at all - I'm afraid Konstantin is rather
> more productive than I can keep up with, and other bugs and patches
> appeared to be more urgent and important.

I'll take a look.

>  And I made a patch for the
> radix-tree test harness which akpm curates, to update its radix-tree.c
> to Konstantin's: those tests ran perfectly on 64-bit and on 32-bit.
> That patch to rtth appended below.

Thanks.

> (I do have, or expect to have once I study them, reservations about
> his subsequent changes to radix-tree usage in mm/shmem.c; and even
> if I end up agreeing with his changes, would prefer to hold them off
> until after the tmpfs fallocation mods are in - other work which
> had to yield to higher priorities, ready but not yet commented.)

OK, I shall forget all about that followup series this time around.

