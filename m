Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0GJLeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 07:34:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0GJLeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 07:34:09 -0400
X-Authority-Analysis: v=1.1 cv=o8sBXTxWt3Y8I13SYZ0pmcTcOViZ+nX/QX6HkgGmvUU= c=1 sm=0 a=T3RyHyitX6oA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=7gkXJVJtAAAA:8 a=AA96hDGzTQzOfXQ6WT4A:9 a=Ia8h96ouusjCG7P1qzjX3fyVmZAA:4 a=PUjeQqilurYA:10 a=JmBWkid0h3cA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: properly align linker defined symbols
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
	 <20100709203301.GA13839@merkur.ravnborg.org>
	 <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com>
	 <1278721339.1537.166.camel@gandalf.stny.rr.com>
	 <20100710063459.GA14596@merkur.ravnborg.org>
	 <AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 10 Jul 2010 07:34:05 -0400
Message-ID: <1278761646.1537.182.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 13:18 +0300, Zeev Tarantov wrote:
> On Sat, Jul 10, 2010 at 09:35, Sam Ravnborg <sam@ravnborg.org> wrote:

> > +/*
> > + * Align to a 32 byte boundary equal to the
> > + * alignment gcc 4.5 uses for a struct
> > + */
> > +#define STRUCT_ALIGN() . = ALIGN(32)
> > +

What I'm nervous about is when gcc 4.8 decides to up the alignment to
64.

Maybe we should have both patches, just to be safe.

-- Steve


