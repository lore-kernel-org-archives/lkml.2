Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2ITINV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:13:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39303 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2ITINQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Thu, 20 Sep 2012 10:13:15 +0200
Message-ID: <CACRpkda+Kav6RGstSQ9+BCgVV+pR6ca_HmoueODYubX_xYM8Jw@mail.gmail.com>
Subject: Re: [PATCH 00/11] pinctrl: mvebu: pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor thing here:

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

>  drivers/pinctrl/pinctrl-armada-370.c               |  421 +++++++++++
>  drivers/pinctrl/pinctrl-armada-xp.c                |  466 ++++++++++++
>  drivers/pinctrl/pinctrl-dove.c                     |  622 ++++++++++++++++
>  drivers/pinctrl/pinctrl-kirkwood.c                 |  460 ++++++++++++
>  drivers/pinctrl/pinctrl-mvebu.c                    |  758 ++++++++++++++++++++
>  drivers/pinctrl/pinctrl-mvebu.h                    |  175 +++++

I've tried to group related implementations together, so if the first four
are dependent we should either:

1. Move all of these to the subdir drivers/pinctrl/mvebu
2. Rename then drivers/pinctrl/pinctrl-mvebu-dove.c (etc)

Either way it's NO BIG DEAL, so I will take care of this after they
are merged unless you feel like just fixing it in-flight at this moment.

Yours,
Linus Walleij
