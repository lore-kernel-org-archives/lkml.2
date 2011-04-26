Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1DZThZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1DZThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:37:24 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=Dki8Cyfhq8zb28wb_yEA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
	 <1303845468.18763.32.camel@gandalf.stny.rr.com>
	 <20110426192029.GA4686@p183>
	 <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:37:22 -0400
Message-ID: <1303846642.18763.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 16:21 -0300, Thiago Farina wrote:
> On Tue, Apr 26, 2011 at 4:20 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
> >> On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
> >> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> >
> >> > >  /**
> >> > > + * streq - Are two strings equal?
> >> > > + * @a: first string
> >> > > + * @b: second string
> >> > > + *
> >> > > + * Example:
> >> > > + *       if (streq(argv[1], "--help"))
> >> > > + *               printf("%s\n", "This help");
> >>
> >> Userspace example?
> >
> > The point is that function is trivial, and if someone doesn't
> > understand it, he should read some Kernighan and Ritchie first.
> >
> 
> I'm fine to remove (should I Steven?). I don't care about the example.
> People reading the code here knows what is this for.

Replace it with something like:

	* Use this: 	streq(a, b)
	* instead of: 	strcmp(a, b) == 0 or !strcmp(a, b)
	* 
	* This makes the code more readable and less error prone.

-- Steve


