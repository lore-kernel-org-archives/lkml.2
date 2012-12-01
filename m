Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2LAXJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 18:09:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61858 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2LAXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 18:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <1354084955.18972.2.camel@phoenix>
References: <1354084955.18972.2.camel@phoenix>
Date: Sun, 2 Dec 2012 00:09:46 +0100
Message-ID: <CACRpkdZtsDHum36NvoCshOP1k+GkUU7WXtX_G9bD7G6-E_LNuw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mmp: select PINCTRL for ARCH_MMP
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 7:42 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This makes PINCTRL related config options visible.
> Otherwise there is no way to build pinctrl drivers for MMP2, PXA168 and PXA910.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This patch was sent on https://lkml.org/lkml/2012/11/12/10
> Resend to Haojian's correct email address.

Applies this as well as an obvious fix.
ACK:s accepted...

Yours,
Linus Walleij
