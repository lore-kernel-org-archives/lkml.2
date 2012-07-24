Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2GXEjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 00:39:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19422 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2GXEjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 00:39:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Jul 2012 21:35:21 -0700
Message-ID: <500E249F.4080700@nvidia.com>
Date: Tue, 24 Jul 2012 09:59:19 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>, "lrg@ti.com" <lrg@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] regulator: tps6586x: add support for input supply
References: <1342187432-18668-1-git-send-email-ldewangan@nvidia.com> <1342187432-18668-3-git-send-email-ldewangan@nvidia.com> <500DB960.6020802@wwwdotorg.org>
In-Reply-To: <500DB960.6020802@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012 02:21 AM, Stephen Warren wrote:
> On 07/13/2012 07:50 AM, Laxman Dewangan wrote:
>>     sm[0-2], ldo[0-9] and ldo_rtc
>> +- sm0-supply: The input supply for the SM0.
>> +- sm1-supply: The input supply for the SM1.
>> +- sm2-supply: The input supply for the SM2.
>> +- vinldo01-supply: The input supply for the LDO1 and LDO2
>> +- vinldo23-supply: The input supply for the LDO2 and LDO3
>> +- vinldo4-supply: The input supply for the LDO4
>> +- vinldo678-supply: The input supply for the LDO6, LDO7 and LDO8
>> +- vinldo9-supply: The input supply for the LDO9
> Hmm. The signal names in my data sheet are VIN_SMn and VINLDOn, so
> having "vin" in just some of the property names seems a little inconsistent.
>

My bad, not sure why I missed it.  I will send the patch for correcting 
this before Tegra's board ventana/harmony fills the dt entry.

