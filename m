Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2KOWwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:52:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10372 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2KOWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:52:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Nov 2012 14:52:27 -0800
Message-ID: <50A5722B.9080707@nvidia.com>
Date: Thu, 15 Nov 2012 17:52:27 -0500
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps6586x: move regulator dt parsing to regulator
 driver
References: <1350569169-27455-1-git-send-email-ldewangan@nvidia.com> <20121115052346.GF7599@opensource.wolfsonmicro.com>
In-Reply-To: <20121115052346.GF7599@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 12:23 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Oct 18, 2012 at 07:36:09PM +0530, Laxman Dewangan wrote:
>> Moving regulator node parsing to regulator driver in place
>> of parsing it on mfd driver.
> Applied, thanks.
>

Thanks, I hope it will not create conflict with Samuel's mfd subsystem 
tree as some changes on same file got merged recently in mfd subsystem.
