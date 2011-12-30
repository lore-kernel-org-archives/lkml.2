Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1L3CIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:08:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41021 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1L3CIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:08:19 -0500
MIME-Version: 1.0
In-Reply-To: <1325051860-12372-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1325051860-12372-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Date: Fri, 30 Dec 2011 03:08:18 +0100
Message-ID: <CACRpkdZQCd_6FgeJWeugtquKyHCu-QzPJzZWi2NHJ=C1XoBneg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/ste_dma40: clear LNK on channel startup
From: Linus Walleij <linus.walleij@linaro.org>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 6:57 AM, Narayanan G
<narayanan.gopalakrishnan@stericsson.com> wrote:

> From: Rabin Vincent <rabin.vincent@stericsson.com>
>
> Otherwise if a previously physical channel is used as a logical channel, the
> LNK may have old values which affect the operation of the logical channel since
> the LNK register has different semantics between physical and logical channels.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Narayanan!
Linus Walleij
