Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1G1GOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:14:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1G1GOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:14:32 -0400
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        tim.bird@am.sony.com
Date: Thu, 28 Jul 2011 09:14:18 +0300
In-Reply-To: <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1311833667.2169.1.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 14:27 +0200, David Wagner wrote:
>  * The numbering of devices is much easier with ubiblk than with
>    gluebi+mtdblock_ro. With gluebi+mtdblock_ro, you get one additional
>    MTD device for each UBI volume, so the number of MTD devices grows
>    quite a lot and is a bit difficult to understand. For example,
>    mtdblock[0-4] might be your real MTD partitions, while mtdblock[5-9]
>    might be your UBI volumes.
>    It also means that if a new real MTD
>    partition is added, the number of all the MTD devices exposing UBI
>    volumes will be incremented by one, which is a bit
>    confusing/annoying.
>    As well, if you add an UBI volume, the mtdblock devices that are
>    emulated on top of volumes that come after this new one will have
>    their ID incremented.
> 
>  * The performance appears to be slightly better with ubiblk than
>    gluebi+mtdblock_ro, according to our benchmarks (see
>    http://elinux.org/Flash_Filesystem_Benchmarks_2.6.39)

Hi, I am having vacation till the middle of August and I do not have a
possibility to look at UBI/UBIFS/MTD stuff now, sorry. When I come back,
I'll go through my e-mails and respond. Apologies again.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

