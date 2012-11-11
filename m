Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2KKTLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 14:11:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39659 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2KKTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 14:11:09 -0500
MIME-Version: 1.0
In-Reply-To: <1352555600.4945.2.camel@phoenix>
References: <1352555600.4945.2.camel@phoenix>
Date: Sun, 11 Nov 2012 20:11:08 +0100
Message-ID: <CACRpkdaABDn4b0NkQObGi6GfFBBZp_HM+sA-wjOP1kdL2HXKzA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinmux: Release all taken pins in
 pinmux_enable_setting error paths
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 2:53 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Currently pinmux_enable_setting does not release all taken pins if
> ops->enable() returns error. This patch ensures all taken pins are
> released in any error paths.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks a *lot* that's a pretty important fix Axel! :-)

Patch applied.

Yours,
Linus Walleij
