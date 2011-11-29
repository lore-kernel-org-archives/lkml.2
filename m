Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1K2IbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:31:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59618 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1K2IbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:31:20 -0500
MIME-Version: 1.0
In-Reply-To: <1322503501-26947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1322503501-26947-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 29 Nov 2011 09:31:18 +0100
Message-ID: <CACRpkdb-5N0nOCCozNX9kOq8xhz5O+2JR5s7j_fkFfh3SU-AqA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add decode of WM8994 GPIO configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 7:05 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

"gpiolib: Add decode of WM8994 GPIO configuration"

Nitpicky: I would write "gpio/wm8994: add decode of gpio configuration" but
that's up to you.

Perhaps some commit blurb about the niceness of decoding stuff here?

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
