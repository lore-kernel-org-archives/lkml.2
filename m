Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3AJLRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:17:11 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:58809 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3AJLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:17:09 -0500
MIME-Version: 1.0
In-Reply-To: <1357493688-25061-4-git-send-email-gregory.clement@free-electrons.com>
References: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
	<1357493688-25061-4-git-send-email-gregory.clement@free-electrons.com>
Date: Thu, 10 Jan 2013 12:17:09 +0100
Message-ID: <CACRpkdZMLQvKSgsGuBqw=O64iZ-yXD-TqetNdv-35BXoGKWkOg@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm: mvebu: enable gpio expander over i2c on Mirabox platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 6:34 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
> through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
> expansion IC to provide 40-bit parallel input/output GPIOs. This patch
> enable the use of this expander on the Mirabox.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Pls merge through the Marvell tree or whatever ARM subtree makes sense.

Yours,
Linus Walleij
