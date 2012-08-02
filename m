Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2HBMEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:04:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10199 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2HBMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:04:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 02 Aug 2012 05:04:51 -0700
Message-ID: <501A69CA.2070507@nvidia.com>
Date: Thu, 2 Aug 2012 17:21:38 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] regulator: tps6586x: add support for SYS rail
References: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com> <20120802114046.GK29157@opensource.wolfsonmicro.com>
In-Reply-To: <20120802114046.GK29157@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2012 05:10 PM, Mark Brown wrote:
> On Thu, Aug 02, 2012 at 04:46:33PM +0530, Laxman Dewangan wrote:
>
>> +static const unsigned int tps6586x_sys_voltages[] = {
>> +	5000000,
>> +};
> Is the system rail actually regulated or is it just a nominal 5V?
> Normally it's just the raw, unregulated input switched in with FETs or
> whatever.

It is unregulated with FET.
The typical range (min-max) shows in data sheet

V(SYS) with respect to AGND1: 2.9V(min) 5.5V(max).
althoguh USB or AC have 4.30V(Min) 16.5V(max)



