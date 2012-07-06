Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2GFGuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:50:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6073 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2GFGuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:50:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jul 2012 23:50:10 -0700
Message-ID: <4FF68978.80703@nvidia.com>
Date: Fri, 6 Jul 2012 12:15:12 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] regulator: tps65910: add support for input supply
References: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com> <4FF5E66A.6010108@wwwdotorg.org> <20120705191129.GQ4111@opensource.wolfsonmicro.com> <4FF5E857.7020204@wwwdotorg.org>
In-Reply-To: <4FF5E857.7020204@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2012 12:47 AM, Stephen Warren wrote:
> On 07/05/2012 01:11 PM, Mark Brown wrote:
>> On Thu, Jul 05, 2012 at 01:09:30PM -0600, Stephen Warren wrote:
>>> On 07/05/2012 08:03 AM, Laxman Dewangan wrote:
>>>> +- vin-xxx-supply: Input voltage supply regulator.
>>> It'd be nice to name these simply xxx-supply; the "vin-" seems
>>> redundant.
>> I suspect the pin is named vin_supply (ie, vin subscript supply) in
>> the datasheet so this is idiomatic.
> That's certainly true on some of the PMICs we use, but not this one
> according to the datasheet I looked at.
As per datasheet of tps65910 and tps65911, the prefix "vin" is not 
there. I took from the other patch discussion.
I will remove it and then send new patch.


