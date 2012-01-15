Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab2AOMIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:08:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46877 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750761Ab2AOMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:08:21 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/yUGweBBbyaCrGLUY7pRWJvgZQS7nfrn3Q0NUDc9
	Z0et0LHj0FLCVL
Subject: Re: Chronic resource starvation.
From: Mike Galbraith <efault@gmx.de>
To: Mike Mestnik <cheako@mikemestnik.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4F11E3B8.6090007@mikemestnik.net>
References: <4F10F3AE.3030801@mikemestnik.net>
	 <4F11E3B8.6090007@mikemestnik.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jan 2012 13:08:15 +0100
Message-ID: <1326629295.6352.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-14 at 14:21 -0600, Mike Mestnik wrote:
> On 01/13/12 21:17, Mike Mestnik wrote:
> > I've dealt with applications taking extended time off for a number of
> > years.  I typically attribute it to applications being overly zealous
> > about eating memory as most every application tends to do these days.  I
> > had always figured that there a likely plenty of ppl complaining and I
> > didn't want to get the boiler plat answer that resources are cheap.
> >
> > I refuse to buy into the idea that Z computers can get an additional Y
> > resource to run application X, when instead application X could be
> > engineered once and for all.  This ideology is not sustainable and
> > eventually will crash upon it's self.  I call this Z * Y < X.  The
> > application source becomes the single location where every computers
> > resources can be increased at the cost of much less then to adjust the
> > running environment of every location that the code may run.
> >
> > Here is a 84MB video that demonstrates the issue.
> > http://j.mp/wavbCO
> > http://bitly.com/wavbCO+
> I'm glad to see a number of you have clicked on this link.
> 
> Does this behavior look normal or is it just my system?  If it is normal
> how difficult would it be to make corrections and would those
> corrections likely be kernel or application related?

That "Backup complete" makes me suspect a classic case of IO-itis.  If
bits of your GUI were pushed out or ram (or weren't previously used),
and live on a disk you're beating hell out of, you get to experience
horrid interactivity while those missing bits are being retrieved.

	-Mike

