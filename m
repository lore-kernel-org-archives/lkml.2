Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab2EISHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:07:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60266 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2EISHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:07:32 -0400
Date: Wed, 9 May 2012 11:07:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: David Miller <davem@davemloft.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.3.x: e1000 and ixgbe hang
Message-ID: <20120509180727.GA14152@kroah.com>
References: <201205082330.12831.wolfgang.walter@stwm.de>
 <201205091107.11820.wolfgang.walter@stwm.de>
 <20120509.120546.788906941073754076.davem@davemloft.net>
 <201205091857.14406.wolfgang.walter@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205091857.14406.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:57:13PM +0200, Wolfgang Walter wrote:
> Am Mittwoch, 9. Mai 2012 schrieben Sie:
> > From: Wolfgang Walter <wolfgang.walter@stwm.de>
> > Date: Wed, 9 May 2012 11:07:11 +0200
> >
> > > c) Dave Miller is a busy man.
> >
> > Therefore pinging me on crap like this makes me a more busy man, so
> > don't do it, unless you want it to take even longer for me to get
> > to it.
> 
> I don't understand why you are so unfriendly.
> 
> I didn't sent you any mail nor did I complain to you. If you read my first 
> mail on this issue then you will see that.

You were complaining to me, about how David isn't working fast enough to
solve a problem that is affecting you, when he said he would take care
of it when he got the chance to.

You didn't say it in so many words, but that was the general gist of it.
And I don't blame David for being brisk, I think it was really crappy of
you to do that.

> But when we are at it: I think that when a bug in a stable kernel is found and 
> the final fix is known it is bad practice to hord that patch till submission 
> without letting stable@ know about it. I don't mean that the patch should go 
> into the stable tree immediately. Of course it makes sense to wait some time 
> to see if it works in Linus' tree. But why should other people waste their 
> time hunting a bug already solved? And why deny people the fix?

No one is "denying" anyone anything, it's all open, you are free to take
the patch and do with it what you want, if you need to.  Some of us have
other responsibilities and tasks and will get to things as soon as we
possibly can.

In other words, trust us, if you don't, that's fine, then do it
yourself, but to try to route around the documented and well-working
procedures that we have in place, is flat out rude.

greg k-h
