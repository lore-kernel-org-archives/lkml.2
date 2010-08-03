Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0HCI4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:56:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42749 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0HCI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=E8TVTW4rYP6Wjd1wGcva79o2UbsI2ZknLq83mzTNSNRpsDctnijELyV7tqRZW8BvwP
         yIzUl8n0q91PTOo+IHT2C0Ye+/QSI7aexOOua35kw2R6MomLwFGNdWd2f7dzXQxl/O3g
         cmCPDUPJDSasL3uSQi/93kMtstPCEoQhuO640=
MIME-Version: 1.0
In-Reply-To: <1279740179-22451-1-git-send-email-linus.walleij@stericsson.com>
References: <1279740179-22451-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 3 Aug 2010 01:56:15 -0700
X-Google-Sender-Auth: idccFWsL3Trmtv6r7fK2Bow8_EI
Message-ID: <AANLkTi=8aR=w0j6-XXSCjqCRJkm5X6XRa0rJ=st5YH=r@mail.gmail.com>
Subject: Re: [PATCH 2/3] DMAENGINE: add runtime slave config to DMA40 v2
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:22 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This extends the DMA engine driver for the DMA40 used in the
> U8500 platform with the generic runtime slave configuration
> interface.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---

What am I missing, this patch does not apply to async_tx.git?

--
Dan
