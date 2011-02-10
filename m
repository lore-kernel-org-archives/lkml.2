Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1BJO3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:29:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52357 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab1BJO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:29:39 -0500
Message-ID: <4D53F606.8020505@ru.mvista.com>
Date: Thu, 10 Feb 2011 17:28:22 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/20] pata_oldpiix: add locking for parallel scanning
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122519.19110.76776.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122519.19110.76776.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2011 15:25, Bartlomiej Zolnierkiewicz wrote:
[...]

> Add an extra locking for parallel scanning.

> This is similar change as commit 60c3be3 for ata_piix host driver

    Linus asks to also specify the commit summary in parens.

> and while pata_oldpiix doesn't enable parallel scan yet the race
> could probably also be triggered by requesting re-scanning of both
> ports at the same time using SCSI sysfs interface.

> Fix documentation while at it.

> Acked-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
> index 433d2fc..845ede1 100644
> --- a/drivers/ata/pata_oldpiix.c
> +++ b/drivers/ata/pata_oldpiix.c
> @@ -1,7 +1,8 @@
>   /*
> - *    pata_oldpiix.c - Intel PATA/SATA controllers
> + *    pata_oldpiix.c - older Intel PATA controllers

    I'd say "controller", since there's only one. :-)

WBR, Sergei
