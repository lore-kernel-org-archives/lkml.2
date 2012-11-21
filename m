Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2KUOwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:52:00 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39307 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2KUOv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:51:58 -0500
MIME-Version: 1.0
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 21 Nov 2012 15:51:54 +0100
Message-ID: <CACRpkdaDC20FfQ2CebUKqySbPTGkk_QJhywZxabK1A5Zdsvvtg@mail.gmail.com>
Subject: Re: [PATCH 00/42] SH pin control and GPIO rework
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 3:27 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> The idea behind these patches is to move SoC-specific pin control code from
> arch/ to drivers/pinctrl/ and use the Linux device model to instantiate the
> pin control device. This is required to add device tree support for the pin
> control device.

Ah, this looks nice :-)

> The SH7264 and SH7269 platforms have no gpiolib support so the PFC code can't
> be compiled for them. As the currently implemented arch-level pinmux support
> also depends on generic GPIO, we're moving from a situation where the code
> isn't used to a different situation where the code isn't used. I don't
> consider that as a regression.

That's OK, would be nice to get rid of this one day though.

I will try to go through and review patches individually. I'll
focus on pinctrl/GPIO mechanisms and trust you and Paul M
to know that the SH side of things are correct.

Yours,
Linus Walleij
