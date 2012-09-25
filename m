Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2IYUAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:00:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65143 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2IYUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <1348573074-11481-1-git-send-email-lee.jones@linaro.org>
References: <1348573074-11481-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 25 Sep 2012 22:00:43 +0200
Message-ID: <CACRpkdZrAMkzgauHLgas7SYxQb_ycgsOvKrMnAz5Z1yzX1-BjA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Move regulator-name properties out to board
 DTS files
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 1:37 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Regulator supply names should be allocated by board rather than
> per SoC, as the same SoC could be wired differently on varying
> hardware. Here we push all regulator-name allocation out to the
> dbx5x0 subordinate board files; HREF and Snowball.
>
> Requested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
