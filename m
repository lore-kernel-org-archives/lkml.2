Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab0J0NP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:15:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63035 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab0J0NPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d0UBSx8xcA/N1vVGKL1IpcDVLXfBbAwfXB9hk1Kui0LOtt4yrnteGBFgMFjKeAfElS
         YN8n9uYCQF4HNuJDCn9vR0su2j6qdkQVpegvzujmOS+kdoNLkdzU31PE6T08Td2mPa+S
         ulWi7KBbI6nud5rG2BOHQn2bkfSYXgwRgu7JE=
MIME-Version: 1.0
In-Reply-To: <20101026132649.623461f9@endymion.delvare>
References: <4CC645A1.5010509@dsn.okisemi.com>
	<20101026102048.316d0c04@endymion.delvare>
	<001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com>
	<20101026111322.738b0b14@endymion.delvare>
	<001c01cb74f2$d3dd8990$66f8800a@maildom.okisemi.com>
	<20101026132649.623461f9@endymion.delvare>
Date: Wed, 27 Oct 2010 09:15:53 -0400
Message-ID: <AANLkTimgCS=U3wzoOtZhtFe0skJtuOaKA+bp+gYc5+qS@mail.gmail.com>
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Wang Qi <qi.wang@intel.com>, Wang Yong Y <yong.y.wang@intel.com>,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        andrew.chih.howe.khor@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/26 Jean Delvare <khali@linux-fr.org>:
> On Tue, 26 Oct 2010 18:47:37 +0900, Tomoya MORINAGA wrote:
>> Must we get Intel's signature ?
>> We have already got the following. Isn't  this enough ?
>> > Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
>>
>> Though I haven't heard like the requirement,
>> if Intel's signature is mandatory, I will request to Intel.
>
> It's not mandatory, but the time Ben and myself have to review new
> drivers is scarce, so it's in your own interest to have the code
> reviewed by people with more time and more interest in the specific
> hardware.

I agree. My Reviewed-by is mainly about the code structure,
a few antipatterns were removed and it looks nice to me now.
We indeed need someone who knows the hardware to look at this.

Yours,
Linus Walleij
