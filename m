Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1F0OZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:25:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1F0OY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YtdvXcGC32FOTlyABvLGapaLivpzgvKJrMV4JK1YvVALsfb23ey2eWClyvP6fzLCuR
         Td7JhxNTqLgdJQC5daYdiRVZDGSgJtRVt+3obM8zP/kkAMDAlxCRidoOH6MJkTMgdoVv
         OCA9Y6uiUPGlbMPlaZuHFYPYn59jXOV+CXoag=
MIME-Version: 1.0
In-Reply-To: <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
Date: Mon, 27 Jun 2011 17:24:56 +0300
Message-ID: <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/27 Rafał Miłecki <zajec5@gmail.com>:
> 2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
>> m68k allmodconfig:
>>
>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>
> We already include slab.h in:
> host_pci.c
> scan.c
> sprom.c
>
> Maybe we can just include this in bcma.h as a better solution?

It isn't better solution.
It results in situation where unnecessary inclusion will be done.
Maybe it's not the case now, but it will be in future.
