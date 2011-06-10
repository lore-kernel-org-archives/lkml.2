Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab1FJEOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 00:14:52 -0400
Received: from mail.perches.com ([173.55.12.10]:2772 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1FJEOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 00:14:51 -0400
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>, Florian Mickler <florian@mickler.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
In-Reply-To: <4DF19565.9070601@gmail.com>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
	 <20110610025532.GE26006@linux-sh.org> <4DF189F2.3040009@gmail.com>
	 <1307675512.20439.2.camel@Joe-Laptop> <4DF18BDC.8010306@gmail.com>
	 <1307676240.20439.9.camel@Joe-Laptop> <4DF1902A.1040305@gmail.com>
	 <20110610035115.GF26006@linux-sh.org>  <4DF19565.9070601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 21:14:48 -0700
Message-ID: <1307679288.20439.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 13:54 +1000, Ryan Mallon wrote:
> Okay, so what is the preferred solution. Do I leave the old address in 
> the files and add MAINTAINERS entries for everything with my correct 
> address, or do I delete my email address (but leave my name) in all of 
> the files?

Another option is to add an entry in .mailmap for
your correct new and incorrect old addresses.

diff --git a/.mailmap b/.mailmap
index 353ad56..218765d 100644
--- a/.mailmap
+++ b/.mailmap
@@ -95,6 +95,7 @@ Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
 Rémi Denis-Courmont <rdenis@simphalempin.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
+Ryan Mallon <rmallon@gmail.com> <ryan@bluewatersys.com>
 Sachin P Sant <ssant@in.ibm.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sascha Hauer <s.hauer@pengutronix.de>


This will only work after get_maintainers is patched
to correctly parse the .mailmap entries that use this form.

I'll chat with Florian to correct this.

cheers, Joe

