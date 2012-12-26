Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2LZAed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 19:34:33 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60453 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2LZAeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 19:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <027101cddf2c$b4f2f9b0$1ed8ed10$@samsung.com>
References: <20121221132014.0bf8772fb3e48c51cec1548a@canb.auug.org.au>
	<027101cddf2c$b4f2f9b0$1ed8ed10$@samsung.com>
Date: Wed, 26 Dec 2012 01:34:29 +0100
Message-ID: <CACRpkdb50D+PMNf9sPTGUs9fsE-QOP0aWB+_aQ6ZpqLuFkvjUg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 4:38 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Stephen Rothwell wrote:
>>
>> Hi all,
>>
>> Today's linux-next merge of the arm-soc tree got conflicts in
>> drivers/pinctrl/pinctrl-exynos5440.c and
>> drivers/pinctrl/pinctrl-samsung.c between commit e5b4c9d4ab55 ("pinctrl:
>> exynos5440: Fix compile error in pinctrl-exynos5440/samsung.c") from the
>> pinctrl tree and commit d5fd5da290ce ("pinctrl: exynos5440/samsung:
>> Staticize pcfgs") from the arm-soc tree.
>>
> Oops, the commit d5fd5da290ce already sent to Linus Torvalds via arm-soc
> tree today. In addition, I applied with Linus Walleij's ack ;-)
>
> Linus Walleij, please drop the patch in your tree. Sorry I didn't notify
> about that when I got the patch from Choi.

OK dropped it, sorry for the delay...

Yours,
Linus Walleij
