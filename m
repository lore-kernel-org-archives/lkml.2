Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab0ENXXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:23:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52032 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab0ENXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qB0qY9Y44/r02t+SZ0dpRRGyfZV/aqjcaB4lHfKruO2t2nIzKYk6Z1zNt3J9ULgNYh
         WLA/qdKsMcI98WksLZgXhP5sqlITmNR4c7QYTxRvCKsJ1OS97DRuytTKkLTFwzZO81CC
         sf7i40xXqi7U7D+4NnMKsFTb/Om67sbMRs7CY=
MIME-Version: 1.0
In-Reply-To: <AANLkTilsUyp4a-mnWLAVXXg6iMFwvBg5d58aViX6umSO@mail.gmail.com>
References: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
	 <AANLkTilsUyp4a-mnWLAVXXg6iMFwvBg5d58aViX6umSO@mail.gmail.com>
Date: Sat, 15 May 2010 08:22:35 +0900
Message-ID: <AANLkTikGRf4FYwWee972jn2PPpmSOz4Qwzp5WKyCMJ1I@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Add dma api driver
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Jassi Brar <jassi.brar@samsung.com>, jy0922.shim@samsung.com,
       maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       ben-linux@fluff.org, dan.j.williams@intel.com,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 5:37 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/5/12 Jassi Brar <jassi.brar@samsung.com>:
>
>> Add DMA Engine API driver for the PL330 DMAC.
>> This driver is supposed to be reusable by various
>> platforms that have one or more PL330 DMACs.
>> Atm, DMA_SLAVE and DMA_MEMCPY capabilities have been
>> implemented.
>>
>> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
>
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
>
> Really looking good now!
Thanks.
Now that the core driver has been accepted by Russell,
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6132/1
 this api driver too could be merged by DMA API maintainers?

regards,
jassi
