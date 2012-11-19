Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2KSJsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:48:23 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:33905 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KSJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:48:22 -0500
Date: Mon, 19 Nov 2012 10:48:09 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: mvebu: fix iomem pointer for dove pinctrl
Message-ID: <20121119104809.6e391917@skate>
In-Reply-To: <1353317996-20841-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1353317996-20841-2-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Mon, 19 Nov 2012 10:39:53 +0100, Sebastian Hesselbarth wrote:
> There has been a change in readl/writel to require registers
> addresses marked as IOMEM(). This patch takes care of this and
> also replaces ORing address offsets with adding them.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Cc: Axel Lin <axel.lin@ingics.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/pinctrl/mvebu/pinctrl-dove.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
