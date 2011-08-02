Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1HBPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:52:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59094 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816Ab1HBPwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:52:30 -0400
X-Sasl-enc: nhtcUuRY0dFYdvlfMpFLSDOSBUZVFTuX/pQUYpOAwk89 1312300350
Date: Tue, 2 Aug 2011 08:48:06 -0700
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, stable@kernel.org,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 024/247] USB: prevent buggy hubs from crashing the
 USB stack
Message-ID: <20110802154806.GC18149@kroah.com>
References: <1308849690-14530-25-git-send-email-paul.gortmaker@windriver.com>
 <Pine.LNX.4.44L0.1106231438530.2033-100000@iolanthe.rowland.org>
 <BANLkTimi7Srt+jgxU3gEt=-XsgLQ1VwCkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimi7Srt+jgxU3gEt=-XsgLQ1VwCkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 03:59:43PM -0400, Paul Gortmaker wrote:
> On Thu, Jun 23, 2011 at 2:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 23 Jun 2011, Paul Gortmaker wrote:
> >
> >> From: Alan Stern <stern@rowland.harvard.edu>
> >>
> >>                    -------------------
> >>     This is a commit scheduled for the next v2.6.34 longterm release.
> >>     If you see a problem with using this for longterm, please comment.
> >>                    -------------------
> >>
> >> commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.
> >>
> >> If anyone comes across a high-speed hub that (by mistake or by design)
> >> claims to have no Transaction Translators, plugging a full- or
> >> low-speed device into it will cause the USB stack to crash.  This
> >> patch (as1446) prevents the problem by ignoring such devices, since
> >> the kernel has no way to communicate with them.
> >
> > This commit had some unexpected fallout.  It shouldn't be merged unless
> > the following upstream commits are also merged:
> >
> > c5c69f3f0dcf9b569c8f3ad67f3af92cfcedac43
> > cee6a262550f53a13acfefbc1e3e5ff35c96182c
> > ec95d35a6bd0047f05fe8a21e6c52f8bb418da55
> 
> Thanks Alan, I'll sort this out and the Nvidia one.    Greg, it looks like
> you have two and three in 32.40, but not #1 (c5c69f) queued up, in
> case that saves you looking.

Thanks, I had missed that one, now queued up.

greg k-h
