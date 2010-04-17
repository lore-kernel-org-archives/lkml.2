Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0DQE6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 00:58:54 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47379 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0DQE6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 00:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kRcSJ/X50qH+C1+Ntdv6OMbZHD093SC4Ouw2UXvgLo3jSgntjx+QzxcRD+cRLkFzRE
         XJuyY/JvO/htrI4XqEfwTZhN9FDCBUFAYlOuHka6OGB1PmOEzle4l2+MiABHTCdK2Foy
         NQ76wIqUfGBrG533rPZy4Q2dNM0+vdK4if5PM=
MIME-Version: 1.0
In-Reply-To: <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
	 <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A03A50F78@EXDCVYMBSTM006.EQ1STM.local>
	 <t2qe9c3a7c21004141815x70ecf123p4364802681417da9@mail.gmail.com>
Date: Sat, 17 Apr 2010 06:58:49 +0200
Message-ID: <q2o63386a3d1004162158v296379fat2b376d5c4c087378@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/15 Dan Williams <dan.j.williams@intel.com>:

> Getting closer... I have pushed out the dma40 driver (v3), 4, and 6.

That's great!

> The other patch in -mm I could take as well but that needs an ack from
> Russell.

Nah, I'll push that in through Russells tree hopefully, it needs rebasing on
the latest board setup code anyway.

> 5 is pending the review comment and 9 does not apply cleanly (does it
> depend on something in the spi tree?)

OK I'm sending updated versions soon, along with a DMA40 bug fix
all on top of async_tx instead.

Number 9 fails since it is based on -next where all the #include <slab.h>
business has taken place, I don't know how that is resolved in the end
but it now includes that include and applies cleanly on async_tx.

I'll keep working on getting the PL011 and PL180 DMA tested on the
RealView somehow so those can also be accepted.

Your,
Linus Walleij
