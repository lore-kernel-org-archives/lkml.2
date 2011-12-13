Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1LMMXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:23:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35498 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LMMXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:23:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAN1soZztU+gC3tkzXK5m51-+djqqcC_JhiJyc4xys2K_ZxUnGA@mail.gmail.com>
	<CACRpkdYFvRDegS63EQzp8pjRMUj7Ru57bK7a+Qq81OkBXmrCBQ@mail.gmail.com>
	<CAN1soZw=51caZjEoxBx8ch0KiE-kgHQFA1amRcTOyDDKe5Ymzw@mail.gmail.com>
Date: Tue, 13 Dec 2011 13:23:16 +0100
Message-ID: <CACRpkdYN9e3L3GD0T6FEYVbHd4nCTfnDSF-M6LexfHUNJ2n+Ww@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 8:21 AM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:

> Excuse me that I didn't find that patch. Did you merge it into your
> git tree?

Yes. It's pushed out and will also be included in linux-next.

> The latest patch on pinconf.c is updating pdev->dev to
> &pdev->dev.

It *should* be the other way around. So pdev->dev points to the
original platform device, and thus you have a handle on that in e.g.
board files where the pin controller is defined and thus you can
apply pin configurations from there.

> By the way, will you merge generic-pinconf into your for-next branch?

Nobody has ACK:ed it and Stephen and Mark both have
unresolved issue with how this should look.

If the current v5 patch suits your needs, please ACK it on the
mailing list so we know that there are people who like this
solution apart from me.

Yours,
Linus Walleij
