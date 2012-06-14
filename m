Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab2FNRNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:13:06 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37366 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2FNRND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FD8BAE4.4050606@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
	<4FD8BAE4.4050606@linaro.org>
Date: Thu, 14 Jun 2012 19:13:02 +0200
Message-ID: <CACRpkdaxoQGukJHy_JUKGu5CRFq5=9NcR-jqjPetMp85kAa-iQ@mail.gmail.com>
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

> From: Lee Jones <lee.jones@linaro.org>
> Date: Wed, 13 Jun 2012 16:21:14 +0100
> Subject: [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device Tree
>  for DB8500 based devices
>
> For correct operation of the i2c-nomadik driver, it requires some
> information surrounding clock-frequencies, delay times and thresholds.
> Here we apply those configurations to be used when a platform is
> booted via the device Tree.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Splendid,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
