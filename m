Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2LEBpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:45:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42896 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2LEBpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <1353522362-25519-2-git-send-email-dianders@chromium.org>
References: <1353450428-2615-2-git-send-email-dianders@chromium.org>
	<1353522362-25519-1-git-send-email-dianders@chromium.org>
	<1353522362-25519-2-git-send-email-dianders@chromium.org>
Date: Wed, 5 Dec 2012 09:45:03 +0800
Message-ID: <CAN1soZyqWk07dqWUmdoknTjw7co8KJLgkO3RT+YY-4QxPg5zdQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-core: dt: Pick i2c bus number from i2c alias if present
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-i2c@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 2:26 AM, Doug Anderson <dianders@chromium.org> wrote:
> This allows you to get the equivalent functionality of
> i2c_add_numbered_adapter() with all data in the device tree and no
> special case code in your driver.  This is a common device tree
> technique.
>
> For quick reference, the FDT syntax for using an alias to provide an
> ID looks like:
>   aliases {
>     i2c0 = &i2c_0;
>     i2c1 = &i2c_1;
>   };
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
>
> ---
>  drivers/i2c/i2c-core.c |  105 +++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 77 insertions(+), 28 deletions(-)
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
