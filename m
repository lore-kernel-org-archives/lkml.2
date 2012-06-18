Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2FRLaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:30:12 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44382 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2FRL3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:45 -0400
MIME-Version: 1.0
In-Reply-To: <4FD8BAE4.4050606@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
	<4FD8BAE4.4050606@linaro.org>
Date: Mon, 18 Jun 2012 13:29:43 +0200
Message-ID: <CACRpkda2pH1by2hajpP20CJgdg+mWFF=QaGbeNdY=c8iOVtLUQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device Tree
 for DB8500 based devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 6:08 PM, Lee Jones <lee.jones@linaro.org> wrote:

> +                       clock-frequency = <100000>;
> +                       stericsson,slsu = <0xe>;
> +                       stericsson,tft = <1>;
> +                       stericsson,rft = <8>;
> +                       stericsson,timeout = <200>;
> +                       stericsson,i2c_freq_mode_fast;

In the context of my patch to the board file, we conclude that the
clock-frequency should be set to 400000 instead.

Yours,
Linus Walleij
