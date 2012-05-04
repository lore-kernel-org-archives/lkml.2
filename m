Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383Ab2EDS6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:58:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2EDS6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:58:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 16:24:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <201205031350.35476.arnd@arndb.de> <20120503144609.GK4141@pengutronix.de>
In-Reply-To: <20120503144609.GK4141@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041624.17850.arnd@arndb.de>
X-Provags-ID: V02:K0:XpsugXqj/Qp/2cjB2DsIHofLDGCDh9VHPBL/6yAHPyH
 sk/b/tv+s3/JpWf2SEVKh9LGEwhirwrKj1gMNcgY6Rp/xDuwyA
 El2ZR+GmY0vqG3WY7qRO45Qj8y7R2OvqF+93rGSscXBOvPrvYt
 jHnr3dLma8u4+B+PYAfzzjqZqK1eZJb1hEJut2iEzIKB6Nsl4Y
 ueFV9U7bJ2qvH/k106C4QQMalya3apHnYxmAWUiLSQWtMvqSEn
 oxwETLSQ+MTDGJ2Bq+xjtu+I/4RlapHvPe6lhGH52PM6pohsKz
 4MwKlGFe8ickXPscihPLUtmdjXQI1eE5UYZyG/ZGPURQucXcZ+
 9v+e92dOkphPaxOBfXJ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Sascha Hauer wrote:
> I don't think that enforcing DT only in multiplatform kernels will speed
> up porting to DT. As a platform maintainer I am interested in building
> multiplatform Kernels, but our customers are mostly uninterested in
> this. They probably disable other platforms anyway to save the binary space.

I was not asking about enabling multiple board files but multiple mach-*
directories, which is something that I'm probably more interested in than
you are, and the customers you refer to would certainly not do that if
they only want to run on one board.

This is really about people who distribute kernels that run on a wide
variety of machines across soc vendor boundaries, people like
ubuntu or cyanogenmod. The question is really whether you see a reason
why they should enable the 25 non-DT board files on your platform, rather
than helping out getting DT support for the machines they are
interested in?

	Arnd

