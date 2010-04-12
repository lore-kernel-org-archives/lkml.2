Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0DLNyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:54:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44718 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0DLNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:54:23 -0400
Message-ID: <4BC325D8.9040607@ru.mvista.com>
Date: Mon, 12 Apr 2010 17:53:28 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 54/64] alim15x3: fix handling of UDMA enable bit
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172126.14623.55960.sendpatchset@localhost>
In-Reply-To: <20100118172126.14623.55960.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] alim15x3: fix handling of UDMA enable bit
>
> Clear UDMA enable bit also for PIO modes.
>   

   Sorry for late mail but I fail to understand why this was done and 
what this patch fixes.

> Based on libata pata_ali host driver.
>   

   libata has different mode programming code where first always the PIO 
mode and then DMA mode is set. With IDE core, the order can be 
different, PIO mode programming shouldn't affect DMA mode bits -- and 
does not affect it in the other drivers...

MBR, Sergei

