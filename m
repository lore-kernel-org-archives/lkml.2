Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2JaQpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:45:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59393 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2JaQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:45:07 -0400
Date: Wed, 31 Oct 2012 09:45:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: new daily bugzilla.kernel.org annoyance messages
Message-ID: <20121031164504.GB1119@kroah.com>
References: <20121031163005.GA411@kroah.com>
 <5091535C.9050103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5091535C.9050103@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:35:40PM -0400, Konstantin Ryabitsev wrote:
> On 31/10/12 12:30 PM, Greg KH wrote:
> > Hi Konstantin,
> > 
> > Who is in charge of bugzilla.kernel.org?  Yesterday I started getting a
> > "Here is a daily list of your outstanding bugs" email, saying:
> > 
> > 	You will get this message once a day until you've dealt with these bugs!
> > 
> > Who made this change?
> > 
> > And how do we turn it off?
> > 
> > Otherwise I'm just going to go and delete my bugzilla.kernel.org
> > account, as that's just about the most annoying thing I've seen in a
> > while.  There are plenty of reasons why you don't want to send out
> > emails like this to developers and to do it every single day is pretty
> > rude.
> 
> Hi, Greg:
> 
> I'm sorry about that -- a few people wanted to use the "whine" option,
> which required that I turn the functionality on. In turn, this annoyed
> everyone with bugs assigned to it.
> 
> Let me see if setting "whinedays" to "0" will turn off the automated
> whines while letting people set up custom whines as they needed. If that
> doesn't work, then I'll set "whinedays" to 3650, so at least this way
> the only bugs you'll get whines about will be those that have been "NEW"
> for over 10 years. :)

Thanks, that would be good.  I didn't see anywhere where I could turn
the "whine" option off, or change it, what screen is it on?

thanks,

greg k-h
