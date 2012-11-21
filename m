Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2KUNQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:16:33 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:56178 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2KUNQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:16:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: viresh kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 17/42] sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
Date: Wed, 21 Nov 2012 14:17:29 +0100
Message-ID: <1694290.k6RRrcIRbt@avalon>
User-Agent: KMail/4.9.2 (Linux/3.5.7-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CAOh2x=kEv1Sgx74jNgdQJL4ivrYVpYhC0kM6--BTk+ibwRm3kg@mail.gmail.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1353464863-10281-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAOh2x=kEv1Sgx74jNgdQJL4ivrYVpYhC0kM6--BTk+ibwRm3kg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wednesday 21 November 2012 08:58:19 viresh kumar wrote:
> On Wed, Nov 21, 2012 at 7:57 AM, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/pinctrl/Kconfig          |    1 +
> >  drivers/pinctrl/Makefile         |    1 +
> >  drivers/pinctrl/sh-pfc/Kconfig   |   24 ++
> >  drivers/pinctrl/sh-pfc/Makefile  |    5 +
> >  drivers/pinctrl/sh-pfc/core.c    |  611 +++++++++++++++++++++++++++++++++
> >  drivers/pinctrl/sh-pfc/core.h    |   54 ++++
> >  drivers/pinctrl/sh-pfc/gpio.c    |  181 +++++++++++
> >  drivers/pinctrl/sh-pfc/pinctrl.c |  481 ++++++++++++++++++++++++++++++
> >  drivers/sh/Kconfig               |    1 -
> >  drivers/sh/Makefile              |    1 -
> >  drivers/sh/pfc/Kconfig           |   18 --
> >  drivers/sh/pfc/Makefile          |    5 -
> >  drivers/sh/pfc/core.c            |  611 ---------------------------------
> >  drivers/sh/pfc/core.h            |   54 ----
> >  drivers/sh/pfc/gpio.c            |  181 -----------
> >  drivers/sh/pfc/pinctrl.c         |  481 ------------------------------
> 
> I haven't gone through the patch, but is it a simple git mv of files?
> If yes, please generate such patches with following command to make review
> really simple:
> 
> git format-patch -C -M

My bad. Will do in the next version.

-- 
Regards,

Laurent Pinchart

