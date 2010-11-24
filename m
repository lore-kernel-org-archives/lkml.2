Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0KXP1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:27:47 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:57245 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0KXP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:27:46 -0500
Subject: Re: trivial: make comment about vs{n,cn,}printf more understandable
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
Cc: Milton Miller <miltonm@bga.com>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1290568857.30543.442.camel@gandalf.stny.rr.com>
References: <1290528765-25057-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1290567844_20137@mail4.comsite.net>
	 <1290568857.30543.442.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 24 Nov 2010 09:27:42 -0600
Message-ID: <1290612462.3159.16.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 22:20 -0500, Steven Rostedt wrote:
> On Tue, 2010-11-23 at 21:04 -0600, Milton Miller wrote:
> > On Tue, 23 Nov 2010 at about 16:12:45 -0000, Uwe Kleine-König wrote:
> > > 
> > > "You probably want ... instead." sounds like a recommendation better
> > > not to use the v... functions.
> > > 
> > 
> > Which is true, if you dont' have a va_list its hard to get them.
> > But I do get your point.
> > 
> > >   * the @buf not including the trailing '\0'. If @size is <= 0 the function
> > >   * returns 0.
> > >   *
> > > - * Call this function if you are already dealing with a va_list.
> > > - * You probably want scnprintf() instead.
> > > + * If you're not already dealing with a va_list better use scnprintf().
> > 
> > That doesn't flow off my (mid-western usa) tounge.
> > 
> > How about
> >  * Call this function if you are already dealing with a va_list.
> >  * Otherwise you probably want to use scnprintf().

> This is closer to what he asked us on IRC ;-)
> 
> But a "do X if Y" is more perl syntax than English (IMHO).
> 
> 
> > 
> > Alternatively,
> >  * If you're not already dealing with a va_list consider scnprintf().
> 
> This isn't bad. My recommendation I gave him was:
> 
>  * If you are already dealing with a va_list, then call this function.
>  * Otherwise you probably want to use scnprintf()

Would be nice if we could lead with the "probably...", but I don't see a
clean way of doing that.    How about a blending of the two:

 * Call this function if you are dealing with a va_list, otherwise use
the scnprintf() function.


> But my upstate NY tongue may not be the best judgment here.
> 
> -- Steve
> 
> "When people ask me what language my mother tongue is, I simply reply 'C'"
> 
> 
> 


