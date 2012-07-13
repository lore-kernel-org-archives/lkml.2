Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161942Ab2GMMn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:43:56 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47708 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab2GMMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:43:55 -0400
Date: Fri, 13 Jul 2012 08:43:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Joe Perches <joe@perches.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/CodingStyle: Mention multi-line macros
 using expressions
In-Reply-To: <1342030482.22278.8.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.02.1207130842530.27681@oneiric>
References: <alpine.DEB.2.02.1207111329280.3642@oneiric> <1342030482.22278.8.camel@joe2Laptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Joe Perches wrote:

> On Wed, 2012-07-11 at 13:32 -0400, Robert P. J. Day wrote:
> []
> > diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> []
> > +A newer technique is to use the GCC extension of being able to place
> > +statements and declarations in an expression, as with this example from
> > +the <linux/kernel.h> header file:
> > +
> > +#define roundup(x, y) (				\
> > +{						\
> > +        const typeof(y) __y = y;		\
> > +        (((x) + (__y - 1)) / __y) * __y;	\
> > +}						\
> > +)
>
> Hi Robert.
>
> How about the phrase "GCC's statement expression extension"
> or maybe give a link like:
> http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

  ok, i'll do that later today.

> Please put the opening ({ and closing )} on a single line.
> It's shorter and makes grep easier.
>
> #define statement_expression(args)		\
> ({						\
> 	etc					\
> })

  i was simply transcribing what was in kernel.h verbatim, but i'll
tuck it together for brevity.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
