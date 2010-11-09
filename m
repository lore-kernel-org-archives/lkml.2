Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0KIUz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:55:26 -0500
Received: from thunk.org ([69.25.196.29]:59256 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab0KIUzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:55:23 -0500
Date: Tue, 9 Nov 2010 15:55:14 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101109205514.GH3099@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Elvis Dowson <elvis.dowson@mac.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20101106181202.GA6927@kroah.com>
 <39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
 <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
 <20101107155757.GA13736@kroah.com>
 <6477C549-DB75-407C-9B9B-5869A3B8D2BD@mac.com>
 <DC5F0A5D-0107-4214-A4D7-6FDA166518BA@mac.com>
 <20101109182437.GA13499@kroah.com>
 <58CAEF9F-BAB3-4F31-A524-70649F965BDE@mac.com>
 <alpine.DEB.2.00.1011091042120.28359@asgard.lang.hm>
 <8EE12C84-9CAE-46F2-8B13-3CF9B9E91F7B@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8EE12C84-9CAE-46F2-8B13-3CF9B9E91F7B@mac.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:52:13PM +0400, Elvis Dowson wrote:
> 
> On Nov 9, 2010, at 10:42 PM, david@lang.hm wrote:
> 
> > you can modify them, but unless those modifications get used, what good are they?
> 
> It would at least help us get android into mainline, and allow
> hand-set manufacturers to baseline from a newer kernel version, and
> prevent the fork.

Ah, but if you make changes to the android userspace that aren't
accepted upstream by the core android development team, you'll be
forking the android userspace.  And given that they are continuing to
add new features to the android userspace, what makes you so sure that
the handset manufacturers will follow *your* tree?

Note also that the handset manufacturers also don't want to reveal
choices they may have made vis-a-vis to-be-released hardware until the
product is ready to ship.  Hence they make their changes in private
trees that only get shared with partners (including the upstream
Android userspace developers at Google as well as their chip
suppliers) when an NDA is signed.

So it's not clear they will be that interested in using a baseline
from a newer kernel version.  Especially if the changes you propose
making to your forked version of the Android userspace don't contain
the latest and greatest user-visible features....

						- Ted

P.S.  These are my opinions only; I don't speak for my employer.
