Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0FTVdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:33:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61594 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0FTVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=IKRarCoAYVecO1vWiIxaFnaSMsPxw8W3tnjhfDzpbWydP4cfbiIGkwlHcXPBB5zpQ/
         6dvp6kkNCIvzm5k4ub++IQMGvtHwm5ZLt8YS/BMhyVlVIT2RKwTxCoKzk116DWtvQOu1
         PbXQaaKDNGYBUpMa4zpn0R2cc+6rX0DEFiVgY=
MIME-Version: 1.0
In-Reply-To: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com>
References: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com>
Date: Sun, 20 Jun 2010 23:33:40 +0200
X-Google-Sender-Auth: KRPvgjIbRNAzDnPB_7NeDV9NCNU
Message-ID: <AANLkTilki98X3SlVHilyjKo8PtPdbM86wbZcvZgU5-BN@mail.gmail.com>
Subject: Re: [PATCH] Add commandline partitions for block devices v2
From: Linus Walleij <linus.walleij@stericsson.com>
To: Andries Brouwer <aeb@cwi.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Ulf Hansson <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/8 Linus Walleij <linus.walleij@stericsson.com>:

> From: Ulf Hansson <ulf.hansson@stericsson.com>
>
> This adds an option to pass in block device partitions from the kernel
> cmdline.

I don't get any reply from this, Andrew could you please stack this
patch up in your tree unless the partition maintainer turns up?

Yours,
Linus Walleij
