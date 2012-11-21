Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2KUEYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:24:12 -0500
Received: from linux-sh.org ([111.68.239.195]:41840 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2KUEYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:24:10 -0500
Date: Wed, 21 Nov 2012 13:23:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 00/42] SH pin control and GPIO rework
Message-ID: <20121121042356.GB14005@linux-sh.org>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 03:27:01AM +0100, Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's a pretty large patch series that rework pin control and GPIO support
> for SH and ARM SH/Renesas Mobile/Car platforms. The patches are based on top
> of v3.7-rc6. You can get them from my git tree at
> 
> 	git://linuxtv.org/pinchartl/fbdev.git pinmux
> 
> The idea behind these patches is to move SoC-specific pin control code from
> arch/ to drivers/pinctrl/ and use the Linux device model to instantiate the
> pin control device. This is required to add device tree support for the pin
> control device.
> 
> The code has been compile-tested on all modified platforms except SH7264 and
> SH7269, and runtime tested on SH7372 (Mackerel), SH73A0 (KZM-A9-GT) and
> R8A7740 (Armadillo) so far. I will runtime test it on R8A7779 (Marzen).
> 
> The SH7264 and SH7269 platforms have no gpiolib support so the PFC code can't
> be compiled for them. As the currently implemented arch-level pinmux support
> also depends on generic GPIO, we're moving from a situation where the code
> isn't used to a different situation where the code isn't used. I don't
> consider that as a regression.
> 
> Sorry for the numerous checkpatch warnings, patches that move code around or
> rename files don't modify the content to make review easier, and thus carry
> warnings from the existing code.
> 
> Currently missing from this series are DT bindings. I will send patches for
> those a bit later. As they will build on top of this series I would appreciate
> reviews (and hopefilly ack's).
> 
I've only given it a quick look, but in general it looks good!

For the series:

Acked-by: Paul Mundt <lethal@linux-sh.org>
