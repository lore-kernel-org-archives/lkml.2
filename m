Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2FSKq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:46:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12066 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2FSKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:46:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Jun 2012 03:46:49 -0700
Message-ID: <4FE0564D.1030709@nvidia.com>
Date: Tue, 19 Jun 2012 16:07:01 +0530
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
References: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com> <1340085087-6608-2-git-send-email-ldewangan@nvidia.com> <20120619093211.GB3974@opensource.wolfsonmicro.com> <4FE04788.5040008@nvidia.com> <20120619104254.GD3974@opensource.wolfsonmicro.com>
In-Reply-To: <20120619104254.GD3974@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2012 04:13 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jun 19, 2012 at 03:04:00PM +0530, Laxman Dewangan wrote:
>
>> I like to go with new series patch for other change once this is accepted.
> I've no concerns with the interface or the code itself other than the
> usability issue with partial deployment so if you could do the updates
> for the other drivers that'd be great.  I'll hold off on applying this
> until we've got everything else updated.

Great. I will send the patch  to reflect this policy for remaining 
regulators.

