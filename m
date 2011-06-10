Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1FJJlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:41:24 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:42464 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1FJJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:41:22 -0400
Date: Fri, 10 Jun 2011 11:33:02 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ryan Mallon <rmallon@gmail.com>
cc: Joe Perches <joe@perches.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
In-Reply-To: <4DF1902A.1040305@gmail.com>
Message-ID: <alpine.LNX.2.00.1106101131540.20200@swampdragon.chaosbits.net>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>  <20110610025532.GE26006@linux-sh.org>  <4DF189F2.3040009@gmail.com>  <1307675512.20439.2.camel@Joe-Laptop>  <4DF18BDC.8010306@gmail.com> <1307676240.20439.9.camel@Joe-Laptop>
 <4DF1902A.1040305@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Ryan Mallon wrote:

> On 10/06/11 13:24, Joe Perches wrote:
> > On Fri, 2011-06-10 at 13:13 +1000, Ryan Mallon wrote:
> > > On 10/06/11 13:11, Joe Perches wrote:
> > > > On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
> > > > > On 10/06/11 12:55, Paul Mundt wrote:
> > > > > > On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
> > > > > > > I no longer work at Bluewater Systems. Update my email address
> > > > > > > accordingly.
> > > > > > Is this sort of churn really necessary?
> > > > get_maintainer uses the name and address in the first seen
> > > > commit matching on the full name where possible.
> > > Okay, what is the correct fix then so that people get the right email
> > > address for me?
> > I believe updating the MAINTAINERS file and
> > authoring and committing patches that take
> > your email address out of files works well.
> 
> If I strip my email address, but leave my name and copyright in the files the
> patch will have the same amount of churn right?
> 
This time around, yes. But the next time you change email you then don't 
have to update those files again, just CREDITS/MAINTAINERS etc.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

