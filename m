Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab1BPIcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:32:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48815 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab1BPIcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nE8ro7uBNc6T9HbmRqwVE+s8dl0oaBYpkPeEQ/ti57J4npuWAVGjr0KIFKciSRKZ71
         EYr1J4fIXeRf2hFj8vOwYHpyiWOIvKVvhG/y2xKJFHglbkkl6bLqU4bVRHzB5Gm3CUSq
         X0051mPOjupKZupEThxN3trNqk3G0Fpk2aR3o=
MIME-Version: 1.0
In-Reply-To: <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
	<1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
Date: Wed, 16 Feb 2011 09:32:15 +0100
X-Google-Sender-Auth: h1Y95ywTL_kc7RoJgUT0gk4fLl0
Message-ID: <AANLkTi=n3=wu802DR3mn2oLgw8zYx+R0nE9rpn1curnH@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Bibek Basu <bibek.basu@stericsson.com>
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/16 Bibek Basu <bibek.basu@stericsson.com>:

> To get rid of port expanders, the free GPIOs of ab8500
> can be used. There are 42 GPIO pins. Out of which 16
> are interrupt capable.This patch implements 16 virtual
> IRQ mapped to 16 interrupt capable AB8500 GPIOs.
>
> Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, when/if this driver is OK with you I'd like to merge it
through the ux500-core tree, so as to get platform data in at
the same time, so request Acked-by: whenever you like it.

Yours,
Linus Walleij
