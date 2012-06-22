Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab2FVLxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:53:05 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7124 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab2FVLxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:53:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 22 Jun 2012 04:52:59 -0700
Message-ID: <4FE45C70.1000503@nvidia.com>
Date: Fri, 22 Jun 2012 17:22:16 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: gpiolib: fix conflicting flag values
References: <1340365736-20161-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1340365736-20161-1-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2012 05:18 PM, Alexandre Courbot wrote:
> Commits aca5ce14 and 25553ff0 introduced two new GPIOF_OPEN_DRAIN and
> GPIOF_OPEN_SOURCE flags to gpiolib. Unfortunately they happen to be the
> same as GPIOF_EXPORT and GPIOF_EXPORT_CHANGEABLE, which causes all gpios
> exported at request time to end up open drain and/or open source.
>
> Resolve the conflict by affecting free flags to GPIOF_EXPORT and
> GPIOF_EXPORT_CHANGEABLE.
>
> Signed-off-by: Alexandre Courbot<acourbot@nvidia.com>
Reviewed-by: Laxman Dewangan <ldewangan@nvidia.com>

Yes, I have sent similar patch in past.
  [PATCH RESEND] gpio: fix bits conflict for gpio flags

Linus W has also Acked it and CCed to stable.



