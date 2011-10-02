Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1JBFsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 01:48:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63166 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1JBFr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 01:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1317470040-2000-1-git-send-email-linkinjeon@gmail.com>
References: <1317470040-2000-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 2 Oct 2011 01:47:57 -0400
Message-ID: <CANz0V+7Bwpa-S0qdW+pN_zu7PJFXQPOONq5WFhMTexddTb=hGg@mail.gmail.com>
Subject: Re: [PATCH v7] mmc : general purpose partition support.
From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        awarkentin@vmware.com, adrian.hunter@intel.com,
        linus.walleij@linaro.org, james_p_freyensee@linux.intel.com,
        sebras@gmail.com, Ulf.Hansson@stericsson.com,
        stefan.xk.nilsson@stericsson.com, per.forlin@stericsson.com,
        johan.rudholm@stericsson.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,

2011/10/1 Namjae Jeon <linkinjeon@gmail.com>:
> It allows gerneral purpose partitions in MMC Device.
> And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
> After patching, we can see general purpose partitions like this.
>> cat /proc/partitions
>          179 0 847872 mmcblk0
>          179 192 4096 mmcblk0gp3
>          179 160 4096 mmcblk0gp2
>          179 128 4096 mmcblk0gp1
>          179 96  1052672 mmcblk0gp0
>          179 64  1024 mmcblk0boot1
>          179 32  1024 mmcblk0boot0
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---

Looks good.

Acked-by: Andrei Warkentin <andrey.warkentin@gmail.com>

Thanks,
A
