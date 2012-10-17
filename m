Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2JQNe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:34:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3070 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2JQNeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:34:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Oct 2012 06:22:49 -0700
Message-ID: <507EB3BF.90009@nvidia.com>
Date: Wed, 17 Oct 2012 19:03:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/4] regulator: tps65090: fix regulator registration
 and add external control support
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com> <20121017132115.GR14199@opensource.wolfsonmicro.com>
In-Reply-To: <20121017132115.GR14199@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012 06:51 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Oct 09, 2012 at 03:18:58PM +0530, Laxman Dewangan wrote:
>> This patch series fixes the regulator registration issue and add support
>> for external control.
>> Patch 1: It renames the driver name and regulators to more appropriate.
>> Patch 2: Fix the issue with regulator registration.
>> Patch 3: Add LDO support.
>> Patch 4: Add voltage output level information.
>> Patch 5: Add support for extenal control for DCDC.
> Applied all four patches, thanks.

Thank you very much.
Laxman
