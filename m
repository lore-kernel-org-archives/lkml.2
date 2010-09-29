Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0I2XaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 19:30:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58653 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0I2XaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 19:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hJ5TkoBgkf6ntRTzSSvEiiUOzTNhIepZVipkvZBGE1duVkL95y6dcBa0ec0EghbBji
         shcpXNmurpUEtJBajL3WGX/q6JUOB3Dz+O6SMBnJhhqpP4330GgP0BaPZqvPFi/DzPPd
         rPe1lJw36A53HTwH5KZxthI66g9f0c45y/QOI=
MIME-Version: 1.0
In-Reply-To: <1285657405-29059-1-git-send-email-linus.walleij@stericsson.com>
References: <1285657405-29059-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 29 Sep 2010 16:30:11 -0700
X-Google-Sender-Auth: 5-w5DtE44Dv5pKwnedRg6YS1AYo
Message-ID: <AANLkTin8PssTzkXq7c+vVRTkN-AWrwh9L=fGU4E_8_UL@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: define a dummy filter function for ste_dma40
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:03 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> All platform data has to be made conditional on CONFIG_STEDMA40
> or we can provide a simple dummy filter functions as to avoid
> cluttering the code with other #ifdef:s.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  arch/arm/plat-nomadik/include/plat/ste_dma40.h |   26 ++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)

This doesn't touch drivers/dma/ so it should go through Russell.

Acked-by: Dan Williams <dan.j.williams@intel.com>
