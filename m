Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2GDKrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:47:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11036 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2GDKrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:47:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 03:47:16 -0700
Message-ID: <4FF41E2D.30104@nvidia.com>
Date: Wed, 4 Jul 2012 16:12:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: fixed: dt: support for input supply
References: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com> <1341223645-7817-2-git-send-email-ldewangan@nvidia.com> <20120703191704.GE29030@opensource.wolfsonmicro.com> <4FF3EA70.307@nvidia.com> <20120704102144.GE4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120704102144.GE4111@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2012 03:51 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jul 04, 2012 at 12:32:08PM +0530, Laxman Dewangan wrote:
>
>> In non-DT, the input supply is passed with the regulator_init_data
>> through the fixed voltage config and it is filled in board files.
> No, this is a legacy way of doing things.  All regulators should be
> moving to specifying the name in their descriptor except for supplies
> that are power roots (which are often fixed voltage regulators).

Then the input_supply should be set through the regulator init data 
"init_data->supply_regulator" rather than the desc? If yes then also I 
need to change the forthcoming patch for tps65910 and tps6586x to pass 
the supply_regulator through init_data.


