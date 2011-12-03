Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1LDKuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:50:10 -0500
Received: from ozlabs.org ([203.10.76.45]:39931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab1LDKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:50:06 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: Greg KH <greg@kroah.com>, Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, siglesia@cern.ch, manohar.vanga@cern.ch,
        dave.martin@linaro.org
Subject: Re: [RFC PATCH V2 0/1] making order in file2alias
In-Reply-To: <20111202192701.GB13860@kroah.com>
References: <87pqg7r8q9.fsf@rustcorp.com.au> <cover.1322781825.git.rubini@gnudd.com> <20111202000350.GA6507@kroah.com> <20111202084213.GA3415@mail.gnudd.com> <20111202192701.GB13860@kroah.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 03 Dec 2011 15:21:43 +1030
Message-ID: <87mxbaqmu8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011 11:27:01 -0800, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 02, 2011 at 09:42:13AM +0100, Alessandro Rubini wrote:
> > > But splitting 15-line functions into separate files?  Less compact, less
> > > simple.
> > 
> > Personally, I'm more interested in the addition of new busses (as
> > drop-in files) than the split up of current ones. But I see your point.
> 
> Yes, that's what me and Linus have asked about having in the past,
> making things easier to merge and the like.  Now admittedly, this file
> isn't all that hard to merge these days given that the addition of new
> busses is pretty rare, these complaints might have been from before git
> times, when merges were harder than they are now.
> 
> Anyway, I like your patch as well, as it seems to get us to that goal.

But it doesn't :( Trivial conflict in file2alias.c becomes trivial
conflict in Makefile.

We could use $(wildcard) in the Makefile, but that's not used much in
the kernel so it'd seem a bit weird.

So honestly, I think we should reorder file2alias.c into alphabetical
order.  In practice, that'll prevent conflicts.

As I said, I'm happy for Alessandro to do the separate file thing *too*,
but if that was the only point, there wasn't one.

Cheers,
Rusty.
