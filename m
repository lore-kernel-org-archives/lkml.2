Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab1JNQzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:55:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42485 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1JNQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:55:40 -0400
Message-ID: <4E986988.6080106@pobox.com>
Date: Fri, 14 Oct 2011 12:55:36 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        David Miller <davem@davemloft.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_pcmcia/ide-cs: move IDs table to <linux/pata_pcmcia_ids.h>
References: <201110131312.14498.bzolnier@gmail.com>
In-Reply-To: <201110131312.14498.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 07:12 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_pcmcia/ide-cs: move IDs table to<linux/pata_pcmcia_ids.h>
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_pcmcia.c       |   74 +---------------------------------------
>   drivers/ide/ide-cs.c            |   74 +---------------------------------------
>   include/linux/pata_pcmcia_ids.h |   70 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 75 insertions(+), 143 deletions(-)

I'm torn...  it is an obvious and simple consolidation, but I dislike 
dropping such a driver-specific turd in include/linux.  I also wonder if 
we want to continue adding new IDs to ide-cs?

David, any opinions?  I'm basically ok with any option:  (a) take Bart's 
patch as-is (with your acked-by), (b) ignore the patch and set a 
no-new-ids policy for ide-cs, (c) other?

	Jeff


