Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab1EMOvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:51:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37598 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab1EMOvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R6rFNuFusv2CY3UX7a/zWfDAIDlSbuGgDnPmlxW1r7MMlqMTXwX4FStK/kS0N7MbLB
         2iPKlUuOgY5JXi5AdJF/n3bGjXuhQZSi0G5gIAqRW9bK1u4DTslTMmlvRAnOkbwGrABc
         h5pNjjOVeZjJsN/zddCtrpWu4CE67+KgeNf7I=
MIME-Version: 1.0
In-Reply-To: <0D753D10438DA54287A00B027084269764D26C443E@AUSP01VMBX24.collaborationhost.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
	<BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
	<0D753D10438DA54287A00B027084269764D26C443E@AUSP01VMBX24.collaborationhost.net>
Date: Fri, 13 May 2011 16:51:17 +0200
X-Google-Sender-Auth: VO9l7J5ojxhnFxrlXEJtxp84Tc8
Message-ID: <BANLkTimSCK1Mc4L7OS=dkijuyNb1uFTtew@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/28 H Hartley Sweeten <hartleys@visionengravers.com>:
> On Thursday, April 28, 2011 12:08 AM, Linus Walleij wrote:
>> 2011/4/27 H Hartley Sweeten <hartleys@visionengravers.com>:
>>> The Makefile should probably be reordered, either alphabetically
>>> or grouped by type (arch/mmio/i2c/spi/pci/etc) and then
>>> alphabetically in order to reduce merge conflicts.
>>
>> Yes, but if I do that in my patchset I will screw up Grants GPIO tree
>> completely, so I prefer that Grant do this. And maybe after pulling
>> in my GPIO consolidation tree to his in that case, so we don't get
>> undesired collisions. So leaving this for the GPIO maintainer.
>
> This comment was intended for the GPIO maintainer.  Sorry for any
> confusion.

Nop problem, I actually made a fix for it that I think Grant can take in
for 2.6.40.

Yours,
Linus Walleij
