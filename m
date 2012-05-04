Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2EDMXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:23:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2EDMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:23:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
Date: Fri, 4 May 2012 08:40:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com> <4FA2C785.2080703@wwwdotorg.org> <20120504.094030.1816474762821188264.hdoyu@nvidia.com>
In-Reply-To: <20120504.094030.1816474762821188264.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205040840.32337.arnd@arndb.de>
X-Provags-ID: V02:K0:K7S2GC5KUWwbqmzi4qGaz2791kq+YLbGoRmsBQRxpXE
 VGHFXL2F6gB4QCpY7exl3AiDTzuVW+V7TmypmPUc7PTik1SvPN
 mR0IgUvZnRHUm0BwktgT3SVAZ5yxjSGKyIQT8dbZ1q+mXCTNY0
 FuP8sXzKoqlZ/FvhL4SUp8lEIcMxAjOy5Rz8zjJyUcCAWly/+E
 o5r+dEKn/KEngcF0jPA3UWZeUMk2/R5ngxoyUuQZgcZuz/YpB5
 Bid6DCpXrOQmYylCS5e+muQJzTR4SN9M8EU2aXf50K8MQmjRPN
 mPbcv7GxgkNJleJYNxMyXbaX8W997IMNjI+u3Hz72H0m2xpMRI
 V+K8XfQHaZpK4G/tOUxE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Hiroshi Doyu wrote:
> > This patch should add
> > Documentation/devicetree/bindings/arm/tegra/tegra20-ahb.txt to describe
> > the DT binding.
> 
> From 'dts' POV, there's no difference between tegra20 and
> tegra30. They just have a register range. Is
> "../bindings/arm/tegra/tegra-ahb.txt" ok, instead of having both
> tegra{20,30}-ahb.txt?

I think either one is ok. Just calling it tegra20-ahb.txt would be
fine too because tegra30 is compatible to that.

	Arnd
