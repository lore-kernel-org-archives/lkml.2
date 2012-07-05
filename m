Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2GETRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:17:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54321 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab2GETRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:17:46 -0400
Message-ID: <4FF5E857.7020204@wwwdotorg.org>
Date: Thu, 05 Jul 2012 13:17:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, lrg@ti.com, swarren@nvidia.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps65910: add support for input supply
References: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com> <4FF5E66A.6010108@wwwdotorg.org> <20120705191129.GQ4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120705191129.GQ4111@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 01:11 PM, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 01:09:30PM -0600, Stephen Warren wrote:
>> On 07/05/2012 08:03 AM, Laxman Dewangan wrote:
> 
>>> +- vin-xxx-supply: Input voltage supply regulator.
> 
>> It'd be nice to name these simply xxx-supply; the "vin-" seems
>> redundant.
> 
> I suspect the pin is named vin_supply (ie, vin subscript supply) in
> the datasheet so this is idiomatic.

That's certainly true on some of the PMICs we use, but not this one
according to the datasheet I looked at.
