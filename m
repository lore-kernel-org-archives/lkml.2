Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2LAXIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:08:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45999 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2LAXIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <1354084640.18972.1.camel@phoenix>
References: <1354084640.18972.1.camel@phoenix>
Date: Sun, 2 Dec 2012 00:08:19 +0100
Message-ID: <CACRpkdYwqGzHZb2Hj0=4Mghv6NS66nCdPBVbBD0wkjSy_EZgxw@mail.gmail.com>
Subject: Re: [PATCH RESEND] pinctrl: Drop selecting PINCONF for MMP2, PXA168
 and PXA910
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 7:37 AM, Axel Lin <axel.lin@ingics.com> wrote:

> These drivers do not need to select PINCONF.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This patch was sent on https://lkml.org/lkml/2012/11/12/12.
> Resend to Haojian's correct email address.

Applied. PXA guys can scream if they don't like it :-)

Yours,
Linus Walleij
