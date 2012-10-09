Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2JIJIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:08:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64982 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2JIJId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <1349496603-20775-5-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-5-git-send-email-cheiny@synaptics.com>
Date: Tue, 9 Oct 2012 11:08:31 +0200
Message-ID: <CACRpkdagphG+z4d-6BREkgOy4Qza=-uKw49Mpn-wPDJKCpudTA@mail.gmail.com>
Subject: Re: [RFC PATCH 04/06] input/rmi4: Config files and makefiles
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com> wrote:

(...)
> diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
(...)
> +config RMI4_DEBUG
> +       bool "RMI4 Debugging"
> +       depends on RMI4_BUS

select DEBUG_FS

This has been illustrated many times in the review. You definatley
have code depending on debugfs when this is selected.

Yours,
Linus Walleij
