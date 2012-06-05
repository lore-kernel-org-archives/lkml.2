Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691Ab2FENRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:17:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56198 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2FENRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb78NY=RmC7bXOKzmBkDHU=DdcJOvDY2uyQ0OPN_v5Rwg@mail.gmail.com>
References: <1338261278-17962-1-git-send-email-festevam@gmail.com>
	<CACRpkdb78NY=RmC7bXOKzmBkDHU=DdcJOvDY2uyQ0OPN_v5Rwg@mail.gmail.com>
Date: Tue, 5 Jun 2012 10:17:42 -0300
Message-ID: <CAOMZO5ABCpwucpUYRmW_xSmVWQWF=vUntxxWGhoHV0imHdA58w@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: Remove redefinition of 'pinctrl_provide_dummies'
From: Fabio Estevam <festevam@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, Jun 5, 2012 at 9:48 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, May 29, 2012 at 5:14 AM, Fabio Estevam <festevam@gmail.com> wrote:
>
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> For mxs_defconfig and imx_v6_v7_defconfig targets, the following
>> build error is observed:
>>
>> drivers/pinctrl/core.c:87:6: error: redefinition of 'pinctrl_provide_dummies'
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Shawn, have a look at this too...
>
> Fabio, please use subject:
> pinctrl: mxs: foo

This error does not show up in linux-next anymore, so please discard this patch.

Regards,

Fabio Estevam
