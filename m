Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1BGMIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:08:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1BGMIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:08:23 -0500
Message-ID: <4D4FE06B.1080705@ru.mvista.com>
Date: Mon, 07 Feb 2011 15:07:07 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide/pmac: housekeeping
References: <201102071152.19326.bzolnier@gmail.com>
In-Reply-To: <201102071152.19326.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-02-2011 13:52, Bartlomiej Zolnierkiewicz wrote:

> * remove legacy IDE_PMAC_DEBUG debugging code
> * rename struct pmac_ide_hwif to struct pmac_ide_priv
> * remove pmac_ide_hwif_t
> * remove needless {dev,pci}_get_drvdata() casts

> Compile-time tested only.

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> Index: b/drivers/ide/pmac.c
> ===================================================================
> --- a/drivers/ide/pmac.c
> +++ b/drivers/ide/pmac.c
[...]
> @@ -698,11 +683,6 @@ set_timings_mdma(ide_drive_t *drive, int
>   		cycleTime = tm[i].cycleTime;
>   		accessTime = tm[i].accessTime;
>   		recTime = tm[i].recoveryTime;
> -
> -#ifdef IDE_PMAC_DEBUG
> -		printk(KERN_ERR "%s: MDMA, cycleTime: %d, accessTime: %d, recTime:
> %d\n",

    Hm, the patch is line-wrapped...

WBR, Sergei
