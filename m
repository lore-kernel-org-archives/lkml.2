Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2HNIUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:20:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61062 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2HNIUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <1344527635-6163-5-git-send-email-lee.jones@linaro.org>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
	<1344527635-6163-5-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:20:36 +0200
Message-ID: <CACRpkdbuXDAMF95V-X-rNdWnkm0maQFH1OM047=KdBrjm33duw@mail.gmail.com>
Subject: Re: [PATCH 4/8] ARM: ux500: Force AB8500 to use the GIC as its
 interrupt controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It's understood that the AB8500 should be subordinate to the DB8500;
> however, the AB8500 uses the GIC as it's interrupt controller. If
> we do not specify which IRQ controller to use the default is to use
> the next encountered IRQ controller as we climb the tree. This would
> be the DB8500. This patch ensures the AB8500 makes use of the correct
> interrupt controller.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
