Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0KXDVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:21:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0KXDVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:21:01 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=SVzli-G6I4cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LFi28DPnIuLyeGUhB8gA:9 a=Hkqeox3ctbDoJUYaY1N3npCgjjoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: trivial: make comment about vs{n,cn,}printf more understandable
From: Steven Rostedt <rostedt@goodmis.org>
To: Milton Miller <miltonm@bga.com>
Cc: u.kleine-koenig@pengutronix.de, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Will Schmidt <will_schmidt@vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1290567844_20137@mail4.comsite.net>
References: <1290528765-25057-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1290567844_20137@mail4.comsite.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 22:20:57 -0500
Message-ID: <1290568857.30543.442.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 21:04 -0600, Milton Miller wrote:
> On Tue, 23 Nov 2010 at about 16:12:45 -0000, Uwe Kleine-König wrote:
> > 
> > "You probably want ... instead." sounds like a recommendation better
> > not to use the v... functions.
> > 
> 
> Which is true, if you dont' have a va_list its hard to get them.
> But I do get your point.
> 
> >   * the @buf not including the trailing '\0'. If @size is <= 0 the function
> >   * returns 0.
> >   *
> > - * Call this function if you are already dealing with a va_list.
> > - * You probably want scnprintf() instead.
> > + * If you're not already dealing with a va_list better use scnprintf().
> 
> That doesn't flow off my (mid-western usa) tounge.
> 
> How about
>  * Call this function if you are already dealing with a va_list.
>  * Otherwise you probably want to use scnprintf().

This is closer to what he asked us on IRC ;-)

But a "do X if Y" is more perl syntax than English (IMHO).


> 
> Alternatively,
>  * If you're not already dealing with a va_list consider scnprintf().

This isn't bad. My recommendation I gave him was:

 * If you are already dealing with a va_list, then call this function.
 * Otherwise you probably want to use scnprintf()

But my upstate NY tongue may not be the best judgment here.

-- Steve

"When people ask me what language my mother tongue is, I simply reply 'C'"



