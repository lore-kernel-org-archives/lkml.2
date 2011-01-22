Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1AVCcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:32:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AVCci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:32:38 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=caeoQ5mqpWkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=9g8v8V-fZgbiv9y2HscA:9 a=YNXltTnWs37ZO12VjcIA:7 a=CZDrKv5Bj8S9_ak3stj_RU371XoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/7] Nexus One Support
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <1295662437.22882.19.camel@m0nster>
References: <20110121094827.41818a55@jbarnes-desktop>
	 <20110121095658.1ab623fe@jbarnes-desktop>
	 <1295632828.19880.22.camel@m0nster>
	 <20110121100441.06a94482@jbarnes-desktop>
	 <1295633882.19880.31.camel@m0nster>
	 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	 <1295642995.19880.42.camel@m0nster>
	 <AANLkTikVDn+W8t7KSym5tCGZowyYvoLFrk8d0mumiRF-@mail.gmail.com>
	 <20110121234930.GK3043@thunk.org> <1295654593.22882.9.camel@m0nster>
	 <20110122015821.GA6249@home.goodmis.org>
	 <1295662437.22882.19.camel@m0nster>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 21 Jan 2011 21:32:36 -0500
Message-ID: <1295663556.12215.4812.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 18:13 -0800, Daniel Walker wrote:
> On Fri, 2011-01-21 at 20:58 -0500, Steven Rostedt wrote:
> > On Fri, Jan 21, 2011 at 04:03:13PM -0800, Daniel Walker wrote:
> > > 
> > > right, but it wasn't a cherrypick which was explain in the thread. So
> > > there's no wrongs here ..
> > 
> > I'm sorry Daniel, but you are absolutely wrong!
> 
> This thread is getting way out of hand .. I think you really don't
> understand what has happened here.. That's fine tho, if you don't like
> what I've done then NAK, I'm not going to argue with any you.

Sorry for coming off a bit strong, but I've known you for a while, and
that is usually the best way to get you to understand.

I don't want to argue, but instead teach you that there is a process of
getting code into the kernel, and a etiquette (not to mention legal) way
of doing things.

If you take code from someone else, look at it, and make it work, or do
whatever changes to it. You must keep some form of authorship with the
original author. If you rewrote it completely so that it doesn't look
anything like what the original code was, then sure, its yours. But then
the copyright would belong to you.

But you stated that the copyright was not yours but googles. You are not
employed by google are you? The major problem I have with these patches
is that you got code from somewhere else but had no Signed-off-bys from
anyone. This is where legal comes in.

How do you know this code was attained legally?  Can you take sole
responsibility that the code was not stolen from non GPL code? The only
tag line in a change log that matters is that Signed-off-by. Its the one
with (sorta) legal powers. This is saying that you verify that this code
was given to you through legal means. Either that you wrote the code
yourself and are not under any contract to keep it from becoming GPL, or
you took it from someone that gave you their own Signed-off-by that you
can trust.

The biggest problem with your patch set is that it is missing the
necessary Signed-off-bys. Also, the only Signed-off-by that you can
write is your own. Someone can give you their Signed-off-by and you can
add it. There's been patches that I would not accept until the author
gave me (usually publicly) their Signed-off-by.


If you had those, I would not have written the email that I wrote.

-- Steve


