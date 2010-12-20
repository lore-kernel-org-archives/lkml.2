Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab0LTWIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:08:22 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:55641 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab0LTWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Vagk+iGtA5z+lyRxMVHnbB6GIHiLE/UMozmzk/nbsEH8zFdIWRWhAoVwsMsAeIhiqP
         4iifeFjsQ/3u4YIjOv9OSxrPbTsHkly+QdUImxqrJEsrnNb1vOmfcjAJXffT2YSd/1Ow
         VV+PErtlzkME+WS+KdvNOlKFUKZg7spAkauys=
MIME-Version: 1.0
In-Reply-To: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
References: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
Date: Mon, 20 Dec 2010 23:08:19 +0100
X-Google-Sender-Auth: 8C3RMQyRmgb_iOArFObU9OfoDZw
Message-ID: <AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dma40: Add support to split up large elements
From: Linus Walleij <linus.walleij@stericsson.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Per Forlin <per.forlin@stericsson.com>:

> The maximum transfer size of the stedma40 is (64k-1) x data-width.
> If the transfer size of one element exceeds this limit
> the job is split up and sent as linked transfer.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

I think this could actually go into 2.6.37 series: I consider it
a bug fix since the transfer size limitation breaks the
contract of the memcpy() API.

Yours,
Linus Walleij
