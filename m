Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2EONQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:16:06 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63943 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab2EONQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <201205151246.45384.arnd@arndb.de>
References: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com>
	<201205151124.13047.arnd@arndb.de>
	<CACRpkdZrs=rgfadRCcMYxhwqib96vkRdHCoC-27dyAjEu5Y5Ew@mail.gmail.com>
	<201205151246.45384.arnd@arndb.de>
Date: Tue, 15 May 2012 15:16:03 +0200
Message-ID: <CACRpkdbjCBi2tkPE-yV7NdHOsMZ_XHuHr3nDUnRekxDDoqRRfw@mail.gmail.com>
Subject: Re: [PATCH 00/12] pinctrl for Ux500 and Nomadik family
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 2:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> One option would be that you just try to be very early with sending your
> branch and arm-soc goes directly after that, another option would be that
> we send a pull request for your tree along with the stuff that depends on
> it, with your permission.

Either way is fine with me, I was planning to send a pull request as soon
as the merge window opens anyway. If you need it, I can lock down the
pinctrl tree and prepare the pull tag.

Yours,
Linus Walleij
