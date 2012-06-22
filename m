Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2FVMAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 08:00:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7476 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761507Ab2FVMAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 08:00:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Jun 2012 04:57:16 -0700
Message-ID: <4FE45EB5.8070309@nvidia.com>
Date: Fri, 22 Jun 2012 21:01:57 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: gpiolib: fix conflicting flag values
References: <1340365736-20161-1-git-send-email-acourbot@nvidia.com> <4FE45C70.1000503@nvidia.com>
In-Reply-To: <4FE45C70.1000503@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I have sent similar patch in past.
>    [PATCH RESEND] gpio: fix bits conflict for gpio flags
>
> Linus W has also Acked it and CCed to stable.

Ah, got your last version from two days ago. Hope this is going to be 
merged this time, it seems like you have been pushing this fix for 2 
months now.

Alex.

