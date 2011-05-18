Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1ERFSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:18:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1ERFSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=SW0J9lV/GCkxzmGQ9AhLwfQYaXslNddWOyaTnTgCjAML7tfvLLL14SVaXNpV2NP89Z
         if1kZ4I8C0id0nwP/GnabsMzi/DetzwrYpUGTe+j0yM6tBx98xoZiw9Lu+i2GH7we34p
         ipzkV9c3iuiC5EVB9XKpfHHBTvz4oRM9swfx0=
MIME-Version: 1.0
In-Reply-To: <20110517211223.GA1909@redhat.com>
References: <1304687191-23814-1-git-send-email-linus.walleij@stericsson.com>
	<201105061522.33179.arnd@arndb.de>
	<20110510055926.GA2747@redhat.com>
	<BANLkTimh2Xaz73v-2c0GmcS9wD4+JFWzrw@mail.gmail.com>
	<20110517211223.GA1909@redhat.com>
Date: Wed, 18 May 2011 07:18:06 +0200
X-Google-Sender-Auth: Bb_0YiUHxUkJDLUTXbz3giV1MMM
Message-ID: <BANLkTi=ADRnkYe8K2qF36bpXC7A3CJhLyw@mail.gmail.com>
Subject: Re: [PATCH 10/10] mach-ux500: update and move cpufreq driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dave Jones <davej@redhat.com>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/17 Dave Jones <davej@redhat.com>:

> From the look of things, the Kconfig is staying under arch/arm for now ?

Actually I use the Kconfig entry for the SoC to build the driver,
that makes the Makefile patch a oneliner and simple to resolve.

I can make a separate Kconfig for it in cpufreq and select it
from the SoC instead.

Linus Walleij
