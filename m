Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2EDVGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:06:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab2EDVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:06:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 21:05:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Christian Robottom Reis <kiko@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <201205031350.35476.arnd@arndb.de> <CACRpkdZ3m=PXg35==3wo2xHPL7TRn1W0AX_CeMKjPd1U+pTAGQ@mail.gmail.com> <20120504204207.GA11715@async.com.br>
In-Reply-To: <20120504204207.GA11715@async.com.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042105.58459.arnd@arndb.de>
X-Provags-ID: V02:K0:QC9ZkTdaFNUwFngPEb5hKBaJxkKAdJoqe1DOaPeJeDG
 P22Xalb8jvnRpoXOtQmxjg3uq5I9i8OAz2OWkJUg482+iXr9n7
 DKfPinjc+0XWSHF5kOI8bBuSTiG+EtM34amnX5FgLuc8KSjxoj
 eIITn/B2MaYTsqXNAa11bnFXaWzArWJEBSy1nXA93cB8b1bgqU
 XxZ3elCdP9thSmp8753S3wcgAsFOWhI7h1hu94Ik5KcHyedBxh
 t6NZs+khgLALtCWaMFPKFomPPNahgaOzHkUhgCFHB0O2jiAopV
 W+mMMXJPtnGrLxHZQb2d4scT9peBFCykQPWugawm5I2lGlh9b+
 Twt47VELQU0xTzqNNKNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Christian Robottom Reis wrote:
> Isn't there work by Pawel that adds support for more of the Versatile
> platform? My quick searching finds at least:
> 
>     http://comments.gmane.org/gmane.linux.drivers.i2c/10143
>     http://comments.gmane.org/gmane.linux.ports.arm.kernel/143523
> 
> I think the latter is merged already, but I may be wrong.

That work was done for versatile express, which is very different
from versatile, although it shares a few devices like the i2c controller
mentioned in the first link.

	Arnd
