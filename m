Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2KUD2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 22:28:21 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53994 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2KUD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 22:28:20 -0500
MIME-Version: 1.0
In-Reply-To: <1353464863-10281-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1353464863-10281-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 21 Nov 2012 08:58:19 +0530
X-Google-Sender-Auth: Ok8LW1ZRV3v_j7drub4fY-gZqSo
Message-ID: <CAOh2x=kEv1Sgx74jNgdQJL4ivrYVpYhC0kM6--BTk+ibwRm3kg@mail.gmail.com>
Subject: Re: [PATCH 17/42] sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
From: viresh kumar <viresh.kumar@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 7:57 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/pinctrl/Kconfig          |    1 +
>  drivers/pinctrl/Makefile         |    1 +
>  drivers/pinctrl/sh-pfc/Kconfig   |   24 ++
>  drivers/pinctrl/sh-pfc/Makefile  |    5 +
>  drivers/pinctrl/sh-pfc/core.c    |  611 ++++++++++++++++++++++++++++++++++++++
>  drivers/pinctrl/sh-pfc/core.h    |   54 ++++
>  drivers/pinctrl/sh-pfc/gpio.c    |  181 +++++++++++
>  drivers/pinctrl/sh-pfc/pinctrl.c |  481 ++++++++++++++++++++++++++++++
>  drivers/sh/Kconfig               |    1 -
>  drivers/sh/Makefile              |    1 -
>  drivers/sh/pfc/Kconfig           |   18 --
>  drivers/sh/pfc/Makefile          |    5 -
>  drivers/sh/pfc/core.c            |  611 --------------------------------------
>  drivers/sh/pfc/core.h            |   54 ----
>  drivers/sh/pfc/gpio.c            |  181 -----------
>  drivers/sh/pfc/pinctrl.c         |  481 ------------------------------

I haven't gone through the patch, but is it a simple git mv of files?
If yes, please generate such patches with following command to make review
really simple:

git format-patch -C -M
