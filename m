Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031294Ab2CQSeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 14:34:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2CQSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 14:34:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Turquette, Mike" <mturquette@ti.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Sat, 17 Mar 2012 18:33:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <201203170905.33191.arnd@arndb.de> <CAJOA=zNVSWR6xZEfx4hioB-Q7M6PsrP9gdvJc1t+YN=QVE=83w@mail.gmail.com>
In-Reply-To: <CAJOA=zNVSWR6xZEfx4hioB-Q7M6PsrP9gdvJc1t+YN=QVE=83w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203171833.27068.arnd@arndb.de>
X-Provags-ID: V02:K0:3wGAXJmHYsPxx47eyGjMRMlOMzux2nj3X+ItIXzETrN
 DtOgH+LZacG8ErQlUtFIiFYaCSSDb+EX2/pib4i3J64bdvCAsB
 tnjTbiIZM+p0NtZWZcOD1h1AyqFgYM7drncQQie52n5sbBHaJf
 7JejX9x14monQDmSFXcI3HMUKqqQNyps7EuPznBt44sNJYcNLV
 SZc9bGeEGPnYwFWpW5S3q8wkXxlFY7/9L5er/GGSeTAz/tqFED
 ZndLc12FN7qQaKqrTKNQfsE5LsTkYTA/MTgBqDi99A+qJkDlky
 R3pGHVBnRh05/1Nwy2hm6DZZmjNLD3aPW11egzyCaEL/go1yNm
 p4/ZdHWF1ZgsIgq8DMZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2012, Turquette, Mike wrote:
> > diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> > index 2eaf17e..a0a83de 100644
> > --- a/drivers/clk/Kconfig
> > +++ b/drivers/clk/Kconfig
> > @@ -12,7 +12,7 @@ config HAVE_MACH_CLKDEV
> >
> >  menuconfig COMMON_CLK
> > -       bool "Common Clock Framework"
> > +       bool
> >        select HAVE_CLK_PREPARE
> >        ---help---
> >          The common clock framework is a single definition of struct
> >          clk, useful across many platforms, as well as an
> 
> Much like experimental I'm not sure how needed this change is.  The
> help section does say to leave it disabled by default, if unsure.  If
> you merge it I won't object but this might be fixing an imaginary
> problem.

Well, it doesn't have any consequences for real users, but it I think it
does for randconfig builds, which we are trying to repair currently.

	Arnd
