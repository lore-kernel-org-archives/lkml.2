Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2ENRJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:09:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5764 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2ENRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:09:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 May 2012 10:09:05 -0700
Message-ID: <4FB13B2D.1000906@nvidia.com>
Date: Mon, 14 May 2012 22:34:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] gpio: fix bits conflict for gpio flags
References: <1336386338-20353-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336386338-20353-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On Monday 07 May 2012 03:55 PM, Laxman Dewangan wrote:
> The bit 2 and 3 in GPIO flag are allocated for the
> flag OPEN_DRAIN/OPEN_SOURCE. These bits are reused
> for the flag EXPORT/EXPORT_CHANGEABLE and so creating
> conflict.
> Fix this conflict by allocating bit 4 and 5 for the
> flag EXPORT/EXPORT_CHANGEABLE.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> ---
> This is broken by commit
> commit fc3a1f04f5040255cbc086c419e4237f29f89f88
> Author: Wolfram Sang<w.sang@pengutronix.de>
>
>      gpio: add flags to export GPIOs when requesting
>
It would be good if it go to 3.5.

Thanks,
Laxman

