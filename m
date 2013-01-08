Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3AHM0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:26:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14930 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3AHM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:26:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jan 2013 04:26:00 -0800
Message-ID: <50EC1046.3000701@nvidia.com>
Date: Tue, 8 Jan 2013 17:55:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] mfd/regulator: tps65090: add DT support and suspend/resume
 cleanups
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Friday 28 December 2012 02:59 PM, Laxman Dewangan wrote:
> The patch series add DT support on TPS65090 device.
>
> Also remove the suspend/resume implementation as it duplicates with
> irq_suspend/irq_resume().
>
> Laxman Dewangan (4):
>    mfd: tps65090: add DT support for tps65090
>    regulator: tps65090: add DT support
>    mfd: tps65090: Pass irq domain when adding mfd sub devices
>    mfd: tps65090: remove suspend/resume callbacks
>


I am not sure that the patches are created on correct sequence for 
adapting this in regulator subsystem and mfd subsystem.
Can you please review whether the changes split is fine or not?
Idea was to make independent patch for mfd and regulator so that they 
can apply independently.

Thanks,
Laxman
