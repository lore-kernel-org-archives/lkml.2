Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab2HCGXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:23:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11822 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2HCGXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:23:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Aug 2012 23:23:17 -0700
Message-ID: <501B6B2D.90508@nvidia.com>
Date: Fri, 3 Aug 2012 11:39:49 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] regulator: tps6586x: add support for SYS rail
References: <1343906193-8309-1-git-send-email-ldewangan@nvidia.com> <501AAE55.3080504@wwwdotorg.org>
In-Reply-To: <501AAE55.3080504@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2012 10:14 PM, Stephen Warren wrote:
> On 08/02/2012 05:16 AM, Laxman Dewangan wrote:
> I believe you need to following patch on top of this, or the sys-supply
> property is not used:

yes, it was missed. I tested with this and it worked fine. Thanks for 
pointing this.

>
> BTW, this patch touches both the regulator and MFD trees. I'm not sure
> who will apply it. I think it relies on the patch to this driver Mark
> recently applied in the regulator tree (for 3.7 I think) doesn't it, at
> least for context?

I looked Mark's regulator for-next and all changes from MFD from Samuel 
is available so I think it will not be issue to apply.



