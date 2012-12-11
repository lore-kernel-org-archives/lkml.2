Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2LKJS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:18:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53235 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2LKJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:18:25 -0500
MIME-Version: 1.0
In-Reply-To: <1355129761-8088-9-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-9-git-send-email-lee.jones@linaro.org>
Date: Tue, 11 Dec 2012 10:18:24 +0100
Message-ID: <CACRpkdbTunT3h9qUz3t6dO4YXLYAnrThpwWNSFMqrVyf4uRggQ@mail.gmail.com>
Subject: Re: [PATCH 08/12] ARM: ux500: Specify which IOS regulator to use for MMCI
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:

> In an effort to move platform specific GPIO controlled regulators
> out from platform code we've created a new mechanism to specify
> them from within the MMCI driver using the supply name 'vmmc-ios'.
> For that to happen when booting device tree, we need to supply it
> in the MMCI (SDI) node.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
