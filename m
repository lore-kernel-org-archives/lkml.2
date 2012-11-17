Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2KQWrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:47:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45493 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KQWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:47:22 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-4-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-4-git-send-email-cheiny@synaptics.com>
Date: Sat, 17 Nov 2012 23:47:21 +0100
Message-ID: <CACRpkdbrY-vUtgHD4-VFV4stivydSniZQpqmU6yFY0tPc97DCg@mail.gmail.com>
Subject: Re: [RFC PATCH 03/06] input/rmi4: I2C physical interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 4:58 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> rmi_i2c.c abstracts an RMI4 device on some arbitrary I2C bus as a logical
> device in the RMI bus.  It handles reads/writes from/to the RMI4 devices,
> and manages the page select register setting (since the meaning of page
> select is dependent on the physical layer used to communicate with the RMi4
> device).
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>

Cut that blank line on all patches.

> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>
>

And that one.

> Acked-by: Jean Delvare <khali@linux-fr.org>

Looks good to me.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
