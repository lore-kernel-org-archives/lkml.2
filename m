Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2EDQuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:50:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41868 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2EDQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:50:23 -0400
Message-ID: <4FA408CB.6060403@wwwdotorg.org>
Date: Fri, 04 May 2012 10:50:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
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
Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com><4FA2C785.2080703@wwwdotorg.org> <20120504.094030.1816474762821188264.hdoyu@nvidia.com>
In-Reply-To: <20120504.094030.1816474762821188264.hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:40 AM, Hiroshi Doyu wrote:
> From: Stephen Warren <swarren@wwwdotorg.org>
> Subject: Re: [PATCHv3 1/4] ARM: tegra: Add Tegra AHB driver
> Date: Thu, 3 May 2012 19:59:33 +0200
> Message-ID: <4FA2C785.2080703@wwwdotorg.org>
> 
>> On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
>>> Tegra AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
>>> High-performance Bus (AHB) architecture.
>>>
>>> The AHB Arbiter controls AHB bus master arbitration. This effectively
>>> forms a second level of arbitration for access to the memory
>>> controller through the AHB Slave Memory device. The AHB pre-fetch
>>> logic can be configured to enhance performance for devices doing
>>> sequential access. Each AHB master is assigned to either the high or
>>> low priority bin. Both Tegra20/30 have this AHB bus.
>>>
>>> Some of configuration param could be passed from DT too.
>>
>> This patch should add
>> Documentation/devicetree/bindings/arm/tegra/tegra20-ahb.txt to describe
>> the DT binding.
> 
> From 'dts' POV, there's no difference between tegra20 and
> tegra30. They just have a register range. Is
> "../bindings/arm/tegra/tegra-ahb.txt" ok, instead of having both
> tegra{20,30}-ahb.txt?

Personally, I prefer to name files using the exact compatible value of
the first SoC version that introduced the HW. This allows e.g.
"tegra40-ahb.txt" to be introduced without making "tegra-ahb.txt" no
longer fully general.
