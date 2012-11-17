Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2KQWlW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:41:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47919 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2KQWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:41:21 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-2-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-2-git-send-email-cheiny@synaptics.com>
Date: Sat, 17 Nov 2012 23:41:18 +0100
Message-ID: <CACRpkdZXGA6tTZHfW0Ou758PD5X-8nqS2q3NgZs6RwQvjLu8yQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/06] input/rmi4: Public header and documentation
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

> rmi.h provides public definitions required by the RMI bus implementation and
> modules that interact with it.
>
> debugfs and sysfs attributes are documented in files in
> Documentation/ABI/testing.  There's two files, one for debugfs and one for
> sysfs.
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>

Cut this white line.

> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>

There is always room for improvement, but you've done a massive
job at fixing this driver to a state which is perfectly maintainable
in the kernel.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
