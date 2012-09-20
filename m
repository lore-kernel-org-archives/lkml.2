Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2ITGeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:34:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34034 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2ITGeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <1347983122-15174-1-git-send-email-lee.jones@linaro.org>
References: <1347983122-15174-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 20 Sep 2012 08:34:20 +0200
Message-ID: <CACRpkdbX_FuZnX2J16UCD1KX-r55KU-st-Fv1AGZhionG6NM7g@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Remove redundant #gpio-cell properties
 from Snowball DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This property has no place here as the populated node is not related
> to a GPIO controller.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
