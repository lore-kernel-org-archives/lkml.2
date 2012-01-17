Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2AQH5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:57:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2AQH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:57:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201152124260.13389@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201152124260.13389@swampdragon.chaosbits.net>
Date: Tue, 17 Jan 2012 08:57:11 +0100
Message-ID: <CACRpkdbp=Z0VWwpEv_4KcDaRpAq8O09v=+yf=gtQ+J87i7P-bg@mail.gmail.com>
Subject: Re: [PATCH] Don't needlessly include linux/version.h in drivers/mfd/ab5500-core.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        trivial@kernel.org, Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 9:26 PM, Jesper Juhl <jj@chaosbits.net> wrote:

> As 'make versioncheck' so nicely points out, there's no need for
> drivers/mfd/ab5500-core.c to #include the linux/version.h header.
> This patch removes the pointless include.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Remnant of some kernelversion-specific code that is now
deleted. Thanks Jesper!

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
