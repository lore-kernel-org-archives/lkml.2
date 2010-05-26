Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0EZVEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:04:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55014 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0EZVEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BamAouWhauIQ3+yCHK9ySn+k+YgEaVrkgc7GsDdZ2VjFagkrSG1CDONkCPd1807+63
         VM+F6g8fpv6sGjO1IG1yJGUrw7XgYvoiy10vezHKR8BjEXjPuyYFxt5Qbuaq7LayUSTb
         8wSVJ4WGCXhkcFRFaplKTjpAf64PX7jv8fF1k=
MIME-Version: 1.0
In-Reply-To: <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
	 <AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
Date: Wed, 26 May 2010 23:04:48 +0200
Message-ID: <AANLkTilhiNOPrM8am1GcJUv3izmRVTYr3gNaSTNKFTUK@mail.gmail.com>
Subject: Re: Controlling Driver Load Order
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Linus Walleij <linus.ml.walleij@gmail.com>:
> 2010/5/26 Robert Emanuele <rob@emanuele.us>:
>
>> On my at91sam9g45 platform I need my i2c drivers to load before the
>> framebuffer driver.  The i2c drivers control a power management IC
>> which is needed to enable the graphics controller.
>>
>> Is there a way to set up that order?
>
> The usual trick (which you can find in a lot of other I2C busses) is to use
> a core_initcall() instead of module_init().

No, sorry that will probably not work.

I meant subsystem_initcall().

Yours,
Linus Walleij
