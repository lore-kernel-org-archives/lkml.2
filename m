Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2EVSru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:47:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17582 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab2EVSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:47:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 May 2012 11:46:27 -0700
Message-ID: <4FBBDE06.5080806@nvidia.com>
Date: Wed, 23 May 2012 00:12:14 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/2] ARM: dt: tegra: cardhu: register core regulator tps65911
References: <1337691917-15040-1-git-send-email-ldewangan@nvidia.com> <1337691917-15040-2-git-send-email-ldewangan@nvidia.com> <4FBBC192.7030900@wwwdotorg.org> <4FBBC830.2060802@nvidia.com> <4FBBCA8F.3050903@wwwdotorg.org> <4FBBD33C.8020802@nvidia.com> <4FBBDA97.6000006@wwwdotorg.org>
In-Reply-To: <4FBBDA97.6000006@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2012 11:57 PM, Stephen Warren wrote:
> On 05/22/2012 11:56 AM, Laxman Dewangan wrote:
>> On Tuesday 22 May 2012 10:49 PM, Stephen Warren wrote:
>>> On 05/22/2012 11:09 AM, Laxman Dewangan wrote:
>>>> On Tuesday 22 May 2012 10:10 PM, Stephen Warren wrote:
>>>>> On 05/22/2012 07:05 AM, Laxman Dewangan wrote:
>>>>>> Add device info for the PMIC device tps65911 in tegra-cardhu
>>>>>> dts file. This device supports the multiple regulator rails,
>>>>>> gpio, interrupts.
> ...
>>>>> Nitpicky, but the labels might be more logical as reg_vdd1 rather than
>>>>> vdd1_reg, but not a big deal.
>>>>>
>>>>> So, please replace the line above with:
>>>>>
>>>>>       reg_vdd1: regulator@0 {
>>>>>           reg =<0>;
>>>> Why do we really require the reg at all?
>>>> I dont think any usage of doing this.
> Oh, perhaps you meant the reg property not "reg_" in the label name?
>
> It is required because the parent node has #address-cells and
> #size-cells and because the node name itself has a unit address ("@nnn").
>

But we can not put
     reg_vdd1:regulator@0 {
         ::::::::::::::
     }


due to their dt binding with their node names.
In this case still do we need  reg=<0> and #address-cells and #size-cells?

