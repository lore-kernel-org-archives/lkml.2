Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab1ERRDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:03:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1ERRDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rzJvibRDF/mjQkiodDM5SKSs9NbTStptoxnz2VAxG/M/+f1Yg4Xhgs2f3MSgPVSBAB
         t6yyGhHZ2rlsKtaIH1mykA7p20TKc3KaYyq3PHxDmY0qWZLaYTIzey+MauR/57FxAijL
         3XOuvVDG45UrBoq6KnOYfbcxlDl6khjGx6Uok=
MIME-Version: 1.0
In-Reply-To: <20110518162558.GA16414@opensource.wolfsonmicro.com>
References: <BANLkTikAzjmVoNK20RHRkhHkn3YgSra6dA@mail.gmail.com>
	<20110518162558.GA16414@opensource.wolfsonmicro.com>
Date: Wed, 18 May 2011 19:03:38 +0200
X-Google-Sender-Auth: tp8_-buAV45JHZa1sRxpAuOfKbk
Message-ID: <BANLkTinc-KXfe3aLgX0DPuSj0_+7gBO0vg@mail.gmail.com>
Subject: Re: Smartcard/SIM card subsystem, LDO regulator and signal modelling
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Bibek BASU <bibek.basu@stericsson.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Juergen Beisert <jbe@pengutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> The above also sounds rather like the standard sort of stuff you get
> with pin muxes - the pulls are certainly very common for random GPIO
> or I2C use, for example.  No real idea on the SIM interface itself.

Yeah :-/

I am now starting to contemplate if I should rename the pinmux
subsystem to "pinctrl" and not only handle muxing but also
biasing in that system.

Linus Walleij
