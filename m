Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1LOWno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:43:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40377 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1LOWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:43:43 -0500
MIME-Version: 1.0
In-Reply-To: <1322831793-25602-1-git-send-email-linus.walleij@stericsson.com>
References: <1322831793-25602-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 15 Dec 2011 23:43:42 +0100
Message-ID: <CACRpkdZEPz-WpGRtPekkRwALjPxYvJ6FEgapNd+SH-jAc1XO1A@mail.gmail.com>
Subject: Re: [PATCH] mfd/abx500: unify abx500 headers in mfd/abx500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I'm anyway around the MFD part of the tree...

Sam is this patch OK?

On Fri, Dec 2, 2011 at 2:16 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> This moves all the header files related to the abx500 family into
> a common include directory below mfd. From now on we place any
> subchip header in that directory. Headers previously in e.g.
> <linux/mfd/ab8500/gpio.h> get prefixed and are now e.g.
> <linux/mfd/abx500/ab8500-gpio.h>. The top-level abstract interface
> remains in <linux/mfd/abx500.h>.
>
> Cc: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
