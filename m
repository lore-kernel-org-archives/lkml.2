Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2AJIwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:52:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51650 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:52:01 -0500
MIME-Version: 1.0
In-Reply-To: <1325643995-20745-3-git-send-email-haojian.zhuang@marvell.com>
References: <1325643995-20745-1-git-send-email-haojian.zhuang@marvell.com>
	<1325643995-20745-3-git-send-email-haojian.zhuang@marvell.com>
Date: Tue, 10 Jan 2012 09:52:01 +0100
Message-ID: <CACRpkdbPk8GEvW7uewMXZcW7ghfry8X0Hgiz3uj4zOrpDgK4hQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] ARM: mmp: enable pinmux in mmp platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 3:26 AM, Haojian Zhuang
<haojian.zhuang@marvell.com> wrote:

> Configuring pinmux in brownstone, aspenite & ttc dkb platform. The functions
> of pins are initialized in platform driver.

I tried to apply this patch but I can't, I suspect it is dependent on
some changes
in the PXA tree?

I can apply this after the merge window once PXA is pulled in and ready.

Yours,
Linus Walleij
