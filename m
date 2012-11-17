Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2KQWpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:45:30 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61615 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2KQWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:45:28 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-3-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-3-git-send-email-cheiny@synaptics.com>
Date: Sat, 17 Nov 2012 23:45:27 +0100
Message-ID: <CACRpkdb6Vj2DuMM4Zb023MpHY4kJaW-xg4cjNYYqvaFQN5Tw+w@mail.gmail.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 4:58 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

> rmi_bus.c implements the basic functionality of the RMI bus.  This file is
> greatly simplified compared to the previous patch - we've switched from
> "do it yourself" device/driver binding to using device_type to distinguish
> between the two kinds of devices on the bus (sensor devices and function
> specific devices) and using the standard bus implementation to manage devices
> and drivers.

I have no further comments, I have reviewed up to my level of competence.
Next you need to fix comments from Greg & Dmitry, which will probably be
just as demanding :-)

But FWIW:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
