Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0EBAsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 20:48:08 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57234 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0EBAsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 20:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b50INhibeqMu82A3uYg65CdtHTg5p0iqorYS9HP1HdJaIm3ZX+2pMFzZwSucFQ8bLt
         bkdHdv4w2O270Ls7GA8q8APrUhmBrJNzJjRKN8oA9QIAMW0JE2smYKkDMIGXiYyepQQP
         bAWGiSXCKtheouztT2La8vi0GZtIPkW3qi3Fg=
MIME-Version: 1.0
In-Reply-To: <1271481165-9848-1-git-send-email-linus.walleij@stericsson.com>
References: <1271481165-9848-1-git-send-email-linus.walleij@stericsson.com>
Date: Sat, 1 May 2010 17:48:01 -0700
X-Google-Sender-Auth: 4193d3759ec8f6ca
Message-ID: <h2te9c3a7c21005011748r234216a2o35c5a979e9e7f0ca@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMAENGINE: add PrimeCell generic DMA to PL022 v6
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 10:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This extends the PL022 SSP/SPI driver with generic DMA engine
> support using the PrimeCell DMA engine interface. Also fix up the
> test code for the U300 platform.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Changes from v5:
> - Rebased on async_tx tree instead

I just back-merged 2.6.34-rc4 into async-tx to pick up the
gfp.h/slab.h conversion... prior to reading this patch.  Can I just
use v5?

--
Dan
