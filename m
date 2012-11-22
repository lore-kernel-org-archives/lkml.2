Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2KVUSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:18:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab2KVUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:18:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121121013133.GE4673@opensource.wolfsonmicro.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
	<1353149747-31871-2-git-send-email-acourbot@nvidia.com>
	<20121120215429.B621F3E1821@localhost>
	<20121121013133.GE4673@opensource.wolfsonmicro.com>
Date: Thu, 22 Nov 2012 09:57:22 +0100
Message-ID: <CACRpkdaNmBpfONDpt7zFqLaqfiGm+ELpO-v5gZmM0rEi_AzijQ@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 2:31 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> As I said in my earlier reviews I think this is a useful thing to have
> as a utility library for drivers independantly of the DT bindings, it
> would allow drivers to become more data driven.  Perhaps we can rework
> the series so that the DT bindings are added as a final patch?  All the
> rest of the code seems OK.

I have the same (limited by experience) opinion. Working sort of
near som audio drivers I have understood that power sequencing
is a big issue not only for things like this backlight example, but
even more so in the area of audio to avoid clicks and pops.

Is it correct to assume that this library will be useful also for ALSA
SoC type of devices?

Then whether to couple that to DT or ACPI or SFI or whatever
is a different discussion altogether.

Yours,
Linus Walleij
