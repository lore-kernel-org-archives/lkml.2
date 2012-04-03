Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2DCF05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:26:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17336 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2DCF0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:26:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Apr 2012 22:26:55 -0700
Message-ID: <4F7A87FA.9050507@nvidia.com>
Date: Tue, 3 Apr 2012 10:47:46 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ldewanagn@nvidia.com" <ldewanagn@nvidia.com>
Subject: Re: [PATCH V2] regulator: fixed: Support for open drain gpio pin
References: <1331116113-22565-1-git-send-email-ldewangan@nvidia.com> <20120402221853.GL3160@opensource.wolfsonmicro.com>
In-Reply-To: <20120402221853.GL3160@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2012 03:48 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Mar 07, 2012 at 03:58:33PM +0530, Laxman Dewangan wrote:
>> Adding flag on fixed regulator board configuration structure
>> to specify whether gpio is open drain type or not.
> Applied, but I had to fix up some conflicts caused by other development
> that had happened in the meantime.  Please check that I resolved those
> correctly.

Verified that the patch applied correctly.

Thanks,
Laxman
