Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2FZJEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:04:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1102 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2FZJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:04:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Jun 2012 02:04:30 -0700
Message-ID: <4FE97AA9.7060805@nvidia.com>
Date: Tue, 26 Jun 2012 14:32:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-3-git-send-email-ldewangan@nvidia.com> <201206201924.09618.arnd@arndb.de> <20120620194609.GA4037@opensource.wolfsonmicro.com> <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de> <20120622084228.GD4037@opensource.wolfsonmicro.com> <20120622085909.GA24121@avionic-0098.mockup.avionic-design.de> <20120622091238.GF4037@opensource.wolfsonmicro.com>
In-Reply-To: <20120622091238.GF4037@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Friday 22 June 2012 02:42 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, Jun 22, 2012 at 10:59:09AM +0200, Thierry Reding wrote:
>> On Fri, Jun 22, 2012 at 09:42:29AM +0100, Mark Brown wrote:
>>> We're talking about consumers here, not the regulator driver finding its
>>> own regulators.
>> No we're not. of_regulator_match() isn't used by consumers but by
>> regulator drivers to parse the DT.
> This subthread has wandered off the topic of the original patch somewhat
> though.

I have not seen much oppose on this series as such and if you are OK on 
this then can we apply?
If it need to buy some ACK from different stack holder then we can ask them.


