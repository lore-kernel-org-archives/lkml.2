Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2EDHkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:40:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46510 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2EDHkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:40:10 -0400
Date: Fri, 4 May 2012 08:39:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Deepak Saxena <dsaxena@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504073951.GB26481@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <CAK2p4sJj7FRVSStVkqmn16sUv8S3vHmUYCU_VzTWAWzqV5yVsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2p4sJj7FRVSStVkqmn16sUv8S3vHmUYCU_VzTWAWzqV5yVsg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 10:38:15PM -0700, Deepak Saxena wrote:
> I'm of the opinion that we support DT only platforms for
> multi-platform but this is based on the approach of only caring for
> multi-platform for newer systems and not worrying too much for legacy
> HW.

You do realise that you're advocating that we forcefully regress stuff
that works today.  Sorry, that's not going to happen.
