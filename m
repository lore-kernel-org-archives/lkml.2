Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab2EDUyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:54:46 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37249 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab2EDUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:54:43 -0400
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Handling of modular boards
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <201205042039.25794.arnd@arndb.de>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <201205041934.08830.arnd@arndb.de> <20120504203357.6B79B206451@gemini.denx.de> <201205042039.25794.arnd@arndb.de>
Comments: In-reply-to Arnd Bergmann <arnd@arndb.de>
   message dated "Fri, 04 May 2012 20:39:25 -0000."
Date: Fri, 04 May 2012 22:54:41 +0200
Message-Id: <20120504205441.D293120645E@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd,

In message <201205042039.25794.arnd@arndb.de> you wrote:
>
> > On the other hand, some of the issues we're trying to solve here
> > for the kernel are also present in the boot loader, so this needs to
> > do this anyway - whether by inserting new or modifying (enabling or
> > disabling) existing properties in the DT is not really relevant here.
> 
> I haven't seen a case where the add-on board is actually required
> for booting. What examples are you thinking of?

There are systems (and I bet it will be a growing number) where U-Boot
itself uses the DT for configuration.  Also, there are functions that
are needed both by the boot loader and the kernel - for example to
dislay a splash screen the boot loader needs to initialize the
display, so it must be able to detect which type of LCD is attached
(resolution, color-depth, orientation) - the device tree comes in very
handy here.  Why should Linux re-do all such things?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I must follow the people.  Am I not their leader? - Benjamin Disraeli
