Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GCIwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:52:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19983 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2GCIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:52:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 03 Jul 2012 01:52:26 -0700
Message-ID: <4FF2B1D7.30205@nvidia.com>
Date: Tue, 3 Jul 2012 14:18:23 +0530
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
Subject: Re: [PATCH 1/2] regulator: fixed: use devm_* for gpio request
References: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com> <20120702172916.GL25093@opensource.wolfsonmicro.com>
In-Reply-To: <20120702172916.GL25093@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 10:59 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 02, 2012 at 03:37:24PM +0530, Laxman Dewangan wrote:
>> Use devm_* version of gpio APIs gpio_request_one() for
>> requesting gpios.
>> This avoid extra code for freeing gpios.
> This can't be applied yet since the export for the devm version hasn't
> been applied so it won't build and also conflicts with the factoring out
> of the GPIO code to the core.
>
Oops, then lets ignore the 1/2 for now. If require, we will revisit later.

But what about 2/2? Does it look good? I can send that as separate patch 
if it is fine.


