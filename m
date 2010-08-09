Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0HIVtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:49:03 -0400
Received: from THUNK.ORG ([69.25.196.29]:40433 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0HIVtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:49:01 -0400
Date: Mon, 9 Aug 2010 17:48:52 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update for 2.6.36
Message-ID: <20100809214852.GK3635@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1OhETF-0005P6-7v@tytso-glaptop>
 <AANLkTinJQ7DQK8_0ngHrbZugFBCgyM5ETUPhcDSmYGP6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinJQ7DQK8_0ngHrbZugFBCgyM5ETUPhcDSmYGP6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 01:17:46PM -0700, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 9:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Which is hopefully what you want.  If you want exactly what is shown
> > below, you can also pull the "next" branch, which omits the merge, and
> > then you can deal with the merge conflict by hand.  The results should
> > be the same either way.
> 
> I did that just to see what it looked like.
> 
> One annoyance: I now get
> 
>   fs/jbd2/transaction.c: In function ‘start_this_handle’:
>   fs/jbd2/transaction.c:98: warning: unused variable ‘ts’
> 
> due to that 'ts' thing only being used for the CONFIG_JBD2_DEBUG case.
> Please fix. I'd suggest putting that CONFIG_JBD2_DEBUG code in a
> helper function of its own, and declaring 'ts' there instead.
> Suggested patch (but with a horrible helper function name) attached.

This is what I have in the ext4 tree.  I'll be sending a pull request
in a day or two with this and maybe one or two other fixups if they
arise.  So far the post-integration testing I've done looks good,
though.

						- Ted

