Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2KHMan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:30:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab2KHMam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:30:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/2] ARM: ux500: add PRCM register base for pinctrl
Date: Thu, 8 Nov 2012 12:30:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1352375731-29570-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352375731-29570-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211081230.11595.arnd@arndb.de>
X-Provags-ID: V02:K0:HgeuJeOT6XXmFNVAWO+OVldLMSC51W5u1A0aLbMO+uP
 QHESjpHTn98KyQUCffqy9KWmYoWQcy4Me4/fWU1iqJ+4o/rvcu
 F24hKHbu4+zK5jOdkFffc+Srui4GcLtyB4hkryLsZHFCpiLvFu
 DTtNRjx/WVVWGpI0O1rWwcRcvB2aRUJc8yDL/chzc58rHa45/j
 cqcWsTTnWJ3ZRZeq+9N2jKoFViFMNSj+0lCkZI7r5FzPrN6M0w
 vGVURGeR5LWED5LG/XzQ3pqvXTv+K7RdYRnNCscjYzvW5tt+Wg
 jryOFa5ujqOwZt3Ea5kHVlCuIsp8KFfh8c5Weg0pXEX+J70j0y
 4GwFMXh9IfzDxy7kjYnA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012, Linus Walleij wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> This adds the PRCM register range base as a resource to
> the pinctrl driver do we can break the dependency to the
> PRCMU driver and handle these registers in the driver
> alone.
> 
> Cc: arm@kernel.org
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
