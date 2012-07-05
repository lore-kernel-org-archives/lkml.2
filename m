Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab2GENXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:23:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50878 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab2GENXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:23:13 -0400
MIME-Version: 1.0
In-Reply-To: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 5 Jul 2012 15:23:13 +0200
Message-ID: <CACRpkdZ7oXM7-ZqmK-21rQ7_J5286GBvkdW21fi_51j+5aKKJA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add support for Wolfson Microelectronics Arizona
 class devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 2:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> The Arizona class devices provide some GPIOs for use in the system. This
> driver provides support for these via gpiolib. Currently interrupts are
> not supported, normally the GPIOs are outputs only.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks,
Linus Walleij
