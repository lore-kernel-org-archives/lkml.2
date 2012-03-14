Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab2CNHnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:43:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19571 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2CNHnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:43:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Mar 2012 00:43:04 -0700
Message-ID: <4F604B12.202@nvidia.com>
Date: Wed, 14 Mar 2012 13:08:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 2/2] regulator: tps65910: Provide settling time for
 DCDC voltage change
References: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com> <1331618721-26326-3-git-send-email-ldewangan@nvidia.com> <20120313232304.GX3177@opensource.wolfsonmicro.com>
In-Reply-To: <20120313232304.GX3177@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2012 04:53 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Mar 13, 2012 at 11:35:21AM +0530, Laxman Dewangan wrote:
>> Settling time is require when there is dcdc rail's voltage change.
>> Returning proper delay time for dcdc voltage change to settle down
>> the output voltage to new value.
> This one doesn't apply, can you check against current topic/drivers
> please?  I suspect a collision with some of Axel's work.

Oops, I should wait for Axel's change to be in next. I resend this patch 
after syncing my tree with your's tree topic/driver.

