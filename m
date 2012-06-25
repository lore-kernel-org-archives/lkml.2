Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2FYRpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:45:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2FYRpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:45:18 -0400
Date: Mon, 25 Jun 2012 10:45:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        Sherwin Soltani <sherwin@wybc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: android: fix binder.c printk macros
Message-ID: <20120625174514.GA3676@kroah.com>
References: <1340431781-2809-1-git-send-email-sherwin@wybc.com>
 <20120625171715.GA29309@kroah.com>
 <1340644800.3359.1.camel@joe2Laptop>
 <20120625172423.GA1935@kroah.com>
 <1340645408.3359.4.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340645408.3359.4.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 10:30:08AM -0700, Joe Perches wrote:
> On Mon, 2012-06-25 at 10:24 -0700, Greg KH wrote:
> > On Mon, Jun 25, 2012 at 10:20:00AM -0700, Joe Perches wrote:
> > > Your patch-bot needs work.
> > > 
> > > Converting printks to pr_<level> is trivial
> > > and should be done all at once, not piecemeal.
> > 
> > I'm not disagreeing with that, unfortunately this patch also did more
> > than just pr_<level> conversions, which is why my patch-bot kicked in.
> > 
> > So your patch-bot complaint generator needs work :)
> 
> Or not.  I think wholesale whitespace changes are just
> fine too.

That's nice, but you aren't the one accepting these patches, sorry.

Also, again, I don't want to see whitespace changes at the same time as
other changes like this, as it makes things harder to review.

> git diff -w can ignore all those things pretty easily.

Ok, but you can't "ignore" those changes before you apply them, which is
what I have to do in reviewing patches.

> Using a bot is certainly sensible and sanity-preserving.
> I think it just needs a little tweaking.

Again, the bot worked properly here, there was more than one logical
change in the patch, so it needs to be split up.  One for the pr_<level>
chanegs, and one for the "lines greater than 80 columns" changes.

If the bot annoys you so much, you can filter it away, or, if others
complain, I can have it not post to mailing lists and only respond to
the original author, but that's generally rude for having a
conversation.

thanks,

greg k-h
