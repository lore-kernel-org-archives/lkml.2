Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2AaIQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:16:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2AaIQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1201302206480.31586@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201302206480.31586@swampdragon.chaosbits.net>
Date: Tue, 31 Jan 2012 09:16:17 +0100
Message-ID: <CACRpkdabd2kVX1pQu2xo2=f5rsuiEDfpF8qfwh7Te-fGtsAUBw@mail.gmail.com>
Subject: Re: [PATCH] mfd, ab5500: Remove unneeded version.h include
From: Linus Walleij <linus.walleij@linaro.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Bibek Basu <bibek.basu@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:08 PM, Jesper Juhl <jj@chaosbits.net> wrote:

> As 'make versioncheck' points out, there's no need for
> drivers/mfd/ab5500-core.c to #include <linux/version.h>, so this patch
> removes the unneeded include.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
