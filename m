Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2KUKA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:00:27 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50187 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2KUKAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:00:24 -0500
MIME-Version: 1.0
In-Reply-To: <1353317996-20841-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1353317996-20841-2-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Wed, 21 Nov 2012 11:00:23 +0100
Message-ID: <CACRpkda=wxmHPk_9uUajYqhbcxxK8bjnYfc-VeLGFif0WUd99Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: mvebu: fix iomem pointer for dove pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> There has been a change in readl/writel to require registers
> addresses marked as IOMEM(). This patch takes care of this and
> also replaces ORing address offsets with adding them.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
