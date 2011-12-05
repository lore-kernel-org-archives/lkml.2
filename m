Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1LERDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:03:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64163 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab1LERDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAA+hA=RM77XORR-cUrFSW_rfn=KG9B1gr-Ny0jcDsU1_NiTT7A@mail.gmail.com>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
	<1322999384-7886-2-git-send-email-b29396@freescale.com>
	<20111204161123.GS27267@pengutronix.de>
	<CAA+hA=RM77XORR-cUrFSW_rfn=KG9B1gr-Ny0jcDsU1_NiTT7A@mail.gmail.com>
Date: Mon, 5 Dec 2011 18:03:10 +0100
Message-ID: <CACRpkdZiyrkezn16ihmB_jQvM2QmG375_8jYykkQNAGCHMZZEA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] pinctrl: imx: add pinmux-imx53 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <b29396@freescale.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 3:43 AM, Dong Aisheng <dongas86@gmail.com> wrote:

> My current plan is to define all (might be frequently) used functoin
> and groups for the exist upstreamed board like 53 Loco and etc, is
> that ok?

Yes, but do it in respective board file, so if we say, one day
stops to support a certain board we can just delete that board
file and be done with it.

Plus this gives us a nice separation as we move toward
device trees. (I think.)

Yours,
Linus Walleij
