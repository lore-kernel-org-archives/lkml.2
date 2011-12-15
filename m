Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1LOFpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:45:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54511 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LOFpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:45:02 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
Date: Thu, 15 Dec 2011 13:45:01 +0800
Message-ID: <CAN1soZyZ79cozpYTYC+L4K-qL0MjyvO49m=5iKNDdS0nRUYJPg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 2:28 AM, Stephen Warren <swarren@nvidia.com> wrote:
> See the Tegra patches I posted for example.
>
>> +++ b/drivers/pinctrl/pinmux-pxa300.c
> ...
>> + *  linux/drivers/pinctrl/pinmux-pxa3xx.c
>
> The comment doesn't match the filename.
>
>> diff --git a/drivers/pinctrl/pinmux-pxa910.c b/drivers/pinctrl/pinmux-pxa910.c
>
> Same comment for this file; it appears to contain the data for two
> different CPUs, and there's no commonality.
>
> --
> nvpublic
>
There's some common code in pxa910 & mmp2 on pin configuration. But
pinconf-generic driver isn't ready now.
