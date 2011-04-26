Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1DZTZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:25:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1DZTZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:25:02 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MEeYj32ODMxs1pVXrywA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110426192029.GA4686@p183>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
	 <1303845468.18763.32.camel@gandalf.stny.rr.com>
	 <20110426192029.GA4686@p183>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 15:25:00 -0400
Message-ID: <1303845900.18763.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 22:20 +0300, Alexey Dobriyan wrote:
> On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
> > On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
> > > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> 
> > > >  /**
> > > > + * streq - Are two strings equal?
> > > > + * @a: first string
> > > > + * @b: second string
> > > > + *
> > > > + * Example:
> > > > + *	if (streq(argv[1], "--help"))
> > > > + *		printf("%s\n", "This help");
> > 
> > Userspace example?
> 
> The point is that function is trivial, and if someone doesn't
> understand it, he should read some Kernighan and Ritchie first.

I understood your point, but I missed looking at it in my first reply.
I'm just stating that it is even worse since it includes a userspace
example of a macro defined in the kernel. IOW, the example wont even
work.

-- Steve

