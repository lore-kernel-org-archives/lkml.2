Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2KQW4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:56:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35670 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2KQW4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-6-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-6-git-send-email-cheiny@synaptics.com>
Date: Sat, 17 Nov 2012 23:56:15 +0100
Message-ID: <CACRpkdZOowrdgP4LTrvywVwsRhh7KZmEmO6t29dy9bcs-2tc3g@mail.gmail.com>
Subject: Re: [RFC PATCH 05/06] input/rmi4: F01 - device control
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

> RMI Function 01 implements basic device control and power management
> behaviors for the RMI4 sensor.
>
> rmi_f01.h exports definitions that we expect to be used by other functionality
> in the future (such as firmware reflash).
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>

Cut blank line.

> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>

All other comments I've had appear to be fixed.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
