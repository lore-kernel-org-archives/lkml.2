Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1D1HKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:10:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58757 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1D1HKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MkX0uIFK4Mlrpt0G1yZMzdsE1CIYcT1+It0OaEXAXTnMhSMKQGruepxK0vO0If9h/f
         roHv5okSOhU4UZC1yffDpnciqUUcS/ggwviCkcRc/NyEyMtNqPyjmF2kez2mq9O/76rb
         TRjgvYm2OdjgjhOEHYFzrifGcpz+W6lOBLg0g=
MIME-Version: 1.0
In-Reply-To: <BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
	<BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
Date: Thu, 28 Apr 2011 09:10:36 +0200
X-Google-Sender-Auth: U-kzeISERU3qKnQvaDGssxwhLwc
Message-ID: <BANLkTimG+DQ3yE6hMiTSHGC6VFQ6Nkq4oA@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/28 Linus Walleij <linus.walleij@linaro.org>:
> 2011/4/27 H Hartley Sweeten <hartleys@visionengravers.com>:
>> # NOTE: platform-specific GPIO drivers don't belong in the
>> # drivers/gpio directory; put them with other platform setup
>> # code, IRQ controllers, board init, etc.
>
> Yeah, you're right. I can take these comments out, simply.
> I'll review the files as bit to make sure there aren't any more
> statements like that.

Thinking of this, the pl061.c driver is already no expansion
chip (it's SoC silicon) so this statement has been wrong for
some time already.

Linus Walleij
