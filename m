Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0ELIiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:38:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0ELIh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pOvqj3uZg3VnqHdN7gZ+Gp7VC8EdeFJS/hlZfdxH1ilqL3KpBoDQg3KW8luNBIvFYA
         xXq7DKJ54fi2c59SmCVVXKejguIpu6Rs6xX7TzQdkFM22espPJi3tYbnB5dSUUPXU01Q
         0B2nxZlSu/CioP1Jhyb3654oQBSfwx4cgsG2c=
MIME-Version: 1.0
In-Reply-To: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
References: <1273641798-26579-1-git-send-email-jassi.brar@samsung.com>
Date: Wed, 12 May 2010 10:37:57 +0200
Message-ID: <AANLkTilsUyp4a-mnWLAVXXg6iMFwvBg5d58aViX6umSO@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Add dma api driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jassi Brar <jassi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       jy0922.shim@samsung.com, maciej.sosnowski@intel.com,
       ben-linux@fluff.org, dan.j.williams@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/12 Jassi Brar <jassi.brar@samsung.com>:

> Add DMA Engine API driver for the PL330 DMAC.
> This driver is supposed to be reusable by various
> platforms that have one or more PL330 DMACs.
> Atm, DMA_SLAVE and DMA_MEMCPY capabilities have been
> implemented.
>
> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>

Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>

Really looking good now!

Yours,
Linus Walleij
