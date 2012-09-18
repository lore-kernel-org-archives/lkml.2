Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2IRMYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:24:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab2IRMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:24:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] ARM: ux500: fix spi2 pin group
Date: Tue, 18 Sep 2012 12:23:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1347962986-12280-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1347962986-12280-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209181223.59918.arnd@arndb.de>
X-Provags-ID: V02:K0:KuittIwHy3Ey9jtnaANKCdehx2/d4JkyitI4PCn1zEM
 nrY7MSFpyH/TJFDhKm39+mDlz1Qxu1+obzw08VKGQiyUp54/Iy
 Og4OQiRb1nreMn7T6rWwVFru3MWmJziyVnH0BcKIa/XGw6RwI7
 FByuZvwYsRRsMVwnyEB8QCR+sKQ14EIeXRWIFvf16GzhlyJ1Aj
 Emh6NIKfu+Gvr49uUIUocIa6NFkDV+y06ZBPt9RlUhO/SaKzNI
 aJgeW3IDk7fwv8tGjum7zJqlUHWond96NWzrgZxj6tDUrIMcc6
 ud4SD3O4pUWdyb728Oo8BAfYeAQLH2rTDigbE/i+sFFPmXjrJN
 FVAAh7rt56I+qH1zcJ9U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@stericsson.com>
> 
> GPIO216_AG12 is configured as a gpio for SPI2, so select
> the spi2_oc1_2 pin group instead of spi2_oc1_1
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Olof, Arnd:
> 
> Again I'd prefer to take this through the pinctrl tree if it's
> OK with you. We are deploying pinctrl internally and ironing out
> bugs as we test more and more use cases.

Acked-by: Arnd Bergmann <arnd@arndb.de>
