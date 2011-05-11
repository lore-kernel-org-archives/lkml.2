Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab1EKARN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:17:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58355 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1EKARM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=apL/PwbLYTka8w6FnLVWO6Tq5QujzxXgzzwxoLnEwmQu/M+ncGCms0b7WKlT9SMlY8
         oPIuO4juIRk1/4Bf9OL2GjzcKitBqcXiPJM79oM7ero7Vvw6DGzkUkZgijl/nXOeniUA
         OypAxlHWXomTn4iVmAx1fIcWwg1be4ryi2Mco=
MIME-Version: 1.0
In-Reply-To: <1304365233.7792.42.camel@Joe-Laptop>
References: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
	<1304365233.7792.42.camel@Joe-Laptop>
Date: Wed, 11 May 2011 02:17:11 +0200
X-Google-Sender-Auth: rRNoMvjvzk5KgMec_DlSryHRE0g
Message-ID: <BANLkTinnPWu9TZ72xdnXayrG0QYF+0mMBg@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/2 Joe Perches <joe@perches.com>:
> On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
> []
>> diff --git a/drivers/pinmux/pinmux-u300.c b/drivers/pinmux/pinmux-u300.c
>> +++ b/drivers/pinmux/pinmux-u300.c
>> +struct u300_pin_desc {
>> +     unsigned number;
>> +     char *name;
>
> const char *name?

Thanks, fixed!

Can I have your reviewed-by for this patch given I fixed that?

Linus Walleij
