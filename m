Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2EGKZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:25:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2EGKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:25:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Date: Mon, 7 May 2012 10:24:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120507074228.GK26481@n2100.arm.linux.org.uk> <201205070859.29174.arnd@arndb.de> <20120507.122333.2024326166703361049.hdoyu@nvidia.com>
In-Reply-To: <20120507.122333.2024326166703361049.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205071024.48958.arnd@arndb.de>
X-Provags-ID: V02:K0:m/r/jNCC7r/HrvQiL8vChTA+WVlmJb4euKtuNMP1FC3
 WUJrMJi8/BsfuOqTdqo2JiM3RAvm4ZMNNOa3RwOAJ0hJQqY24r
 OtGL+qDiW3OnkcrRsXQHL1pe/AWmNkkrcwmvmG4WXtTqVBP3Rl
 39wq8nVkH+zrFSO/un/JXbPg17omqyxwo7SA6EDijpZGKlQ+lm
 jenJ/NolwyWC6CWupCVjJRMJkeMbq9JoAbHj8LrDCUoT6Qg+qL
 isQZ6hUhzTJNnZMbcQU6kPiJFXNAfy1UL744QuqOEVdaVCl9Og
 dOzQ5UQFhDu9pYNx1iwJfgz+R61QutqCM4zI9FI/fGgE2Mq62c
 32EsUgUvJHZr16nOhaBc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012, Hiroshi Doyu wrote:
> Tegra doesn't enable ARM_AMBA and Tegra doesn't use the following
> "drivers/amba/bus.c" right now. I needed to make this directory
> available to ones without ARM_AMBA enabled.

Ah, right. I looked at arch/arm/Kconfig earlier to see if
tegra enabled ARM_AMBA but was accidentally looking
at ARCH_INtegraTOR when grepping for TEGRA ;-)

Your proposed solution sounds good then.

	Arnd
