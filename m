Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0EGMuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:50:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43287 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0EGMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZLtF93OiiL4vZh5tVdICMX6lLSVRJ7+1wNdWK+VLmFsSSYUk0sKrVvHLIL8YYT83xT
         OC1Ta0pIpQ6tnXMOCiW4bTMrRfFDu+ylm7Q6ZvYWpEpUebl3ty1KEiYAeKac0NuucC9l
         v5a6mjKnJjQGLAkNbKHKbUOjctKRvEfVS2RLc=
MIME-Version: 1.0
In-Reply-To: <i2r63386a3d1005070159tf0879839u24c1c1f11466970d@mail.gmail.com>
References: <1273215671-3090-1-git-send-email-jassisinghbrar@gmail.com>
	 <i2r63386a3d1005070159tf0879839u24c1c1f11466970d@mail.gmail.com>
Date: Fri, 7 May 2010 21:50:50 +0900
Message-ID: <q2p1b68c6791005070550xc0a90815w6ff676c6c32235e1@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMA: PL330: Add async dma api driver
From: jassi brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       dan.j.williams@intel.com, ben-linux@fluff.org, jy0922.shim@samsung.com,
       maciej.sosnowski@intel.com, Jassi Brar <jassi.brar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 5:59 PM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/5/7 Jassi Brar <jassisinghbrar@gmail.com>:
>
>> Add ASYNC DMA Engine API driver for the PL330 DMAC.
>> This driver is supposed to be reusable by various
>> platforms that have one or more PL330 DMACs.
>> Atm, DMA_SLAVE and DMA_MEMCPY capabilities have been
>> implemented.
>>
>> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>

.....

> If you fix this and test it on async_tx it's:
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
Will do.
Thanks.
