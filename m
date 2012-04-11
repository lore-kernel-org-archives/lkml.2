Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2DKIfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:35:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43027 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2DKIff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F84537A.2020300@wwwdotorg.org>
References: <1334045048-15566-1-git-send-email-linus.walleij@stericsson.com>
	<4F84537A.2020300@wwwdotorg.org>
Date: Wed, 11 Apr 2012 10:35:34 +0200
Message-ID: <CACRpkdYc3fbwX6oPKm8JAZLG-51vDXhihGqk=HAoS9Xz+BnF=A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: implement pinctrl deferred probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 5:36 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

>> @@ -521,8 +521,11 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
>>               dev_err(p->dev, "unknown pinctrl device %s in map entry",
>>                       map->ctrl_dev_name);
>
> Perhaps this dev_err (and the one in the other hunk) should be
> downgraded to warn/info/debug?

I've downgraded to dev_info() for now (see v2), I suspect people may have some
problems with deferred probing ATM so better log something for them. Later we
may set it to dev_dbg() if it looks too noisy...

Thanks,
Linus Walleij
