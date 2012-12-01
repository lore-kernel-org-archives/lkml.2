Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2LARHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:07:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52574 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2LARHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:07:07 -0500
MIME-Version: 1.0
In-Reply-To: <1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20121125152845.GV15800@titan.lakedaemon.net>
	<1353921525-25163-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Sat, 1 Dec 2012 18:07:06 +0100
Message-ID: <CACRpkdZcHsvSG-vfynd0jYrs0kVYqPsgtroSrQdz4yDZexQZjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add pinctrl clock to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 10:18 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> During merge of the mvebu patches a clock gate for pinctrl was
> lost. This patch just readds the clock gate.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

So who's supposed to merge this patch? Me? The MVEBU-maintainer?

Yours,
Linus Walleij
