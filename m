Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2KUIAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:00:42 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38879 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2KUIAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:00:41 -0500
MIME-Version: 1.0
In-Reply-To: <1353479636.20245.2.camel@phoenix>
References: <1353479636.20245.2.camel@phoenix>
Date: Wed, 21 Nov 2012 09:00:40 +0100
Message-ID: <CACRpkdZjdnd3w4hdDGB32f6ET=P_5yex7U2tp7u4+5Geder70g@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Fix use after free in gpiochip_add_pin_range
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 7:33 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This is introduced by commit 9ab6e988
> "gpiolib: return any error code from range creation".
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This patch is against LinusW's linux-pinctrl tree, for-next branch.
> Axel

Oops thanks a lot for catching this Axel!

Yours,
Linus Walleij
