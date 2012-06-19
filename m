Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2FSJnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:43:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6705 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2FSJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:43:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Jun 2012 02:41:05 -0700
Message-ID: <4FE04788.5040008@nvidia.com>
Date: Tue, 19 Jun 2012 15:04:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: support for regulator match by regulator-compatible
References: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com> <1340085087-6608-2-git-send-email-ldewangan@nvidia.com> <20120619093211.GB3974@opensource.wolfsonmicro.com>
In-Reply-To: <20120619093211.GB3974@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2012 03:02 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jun 19, 2012 at 11:21:26AM +0530, Laxman Dewangan wrote:
>> Add API to match the chip regulator's id by the
>> property of "regulator-compatible" on regulator node.
> We shouldn't have two different methods for doing this, we should
> standardise this over all regulator drivers (or at the very least those
> using the existing framework code) - having the old framework in place
> will at best be confusing for authors of new drivers.  We either need to
> make it clear which framework to use or (ideally) remove the old
> framework.

Agree. Currently following regulators are using this (based on grep)
mfd/tps6586x.c
regulator/ab8500.c
regulator/db8500-prcmu.c
and regulator/tps65910.

If the related change in tps65910 is fine and there is no more 
concern/feedback on the approach then I can create a series of patch to 
modify the other regulator and related dts file to follow the same.

If you want, I can make the new changes as part of this series or can 
start with new series.

I like to go with new series patch for other change once this is accepted.

