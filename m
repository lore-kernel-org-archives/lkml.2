Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1FJDYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:24:04 -0400
Received: from mail.perches.com ([173.55.12.10]:2763 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1FJDYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:24:03 -0400
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
In-Reply-To: <4DF18BDC.8010306@gmail.com>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
	 <20110610025532.GE26006@linux-sh.org>  <4DF189F2.3040009@gmail.com>
	 <1307675512.20439.2.camel@Joe-Laptop>  <4DF18BDC.8010306@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 20:24:00 -0700
Message-ID: <1307676240.20439.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 13:13 +1000, Ryan Mallon wrote:
> On 10/06/11 13:11, Joe Perches wrote:
> > On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
> >> On 10/06/11 12:55, Paul Mundt wrote:
> >>> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
> >>>> I no longer work at Bluewater Systems. Update my email address accordingly.
> >>> Is this sort of churn really necessary?
> > get_maintainer uses the name and address in the first seen
> > commit matching on the full name where possible.
> Okay, what is the correct fix then so that people get the right email 
> address for me?

I believe updating the MAINTAINERS file and
authoring and committing patches that take
your email address out of files works well.

Some think that it's better to keep current
email addresses in the files.  I think it
has to do with European data retention laws.

Not sure if that applies to you.

There've been threads about changing email
addresses in files before like:

https://lkml.org/lkml/2011/4/10/89

cheers, Joe

