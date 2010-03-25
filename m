Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0CYI0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:26:45 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44296 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0CYI0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WlVtbZ6FndNSm0D6HFF3eblm8Ls8N9EuWolnp4X0GWNI11BsqpXsHXimyX0v2nRVbq
         y4K8BaM418Y3L8L4IPunSE7LOq1haifb+8OQL8skKv4n2w4vDM8THGZrQ15rbE7boCHy
         lulz7xGW3c/tsY3Ji5VhCpBrxzJXUnzCpImjk=
MIME-Version: 1.0
In-Reply-To: <4BAAD5BB.7050101@samsung.com>
References: <4BAAD5BB.7050101@samsung.com>
Date: Thu, 25 Mar 2010 09:26:40 +0100
Message-ID: <63386a3d1003250126j4726a709o6bb0dc1355dc911e@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dan.j.williams@intel.com, kyungmin.park@samsung.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/25 Joonyoung Shim <jy0922.shim@samsung.com>:

> The PL330 is currently the dma controller using at the S5PC1XX arm SoC.
> This supports DMA_MEMCPY and DMA_SLAVE.

Looks good to me now so:
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Linus Walleij
