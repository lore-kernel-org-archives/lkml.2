Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2HNLOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:14:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48715 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2HNLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:14:46 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-15-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-15-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:14:46 +0200
Message-ID: <CACRpkdbA87mRK23=t0vXg4jXNw-cW3Pepz5J3brBtbtJAz0saQ@mail.gmail.com>
Subject: Re: [PATCH 14/22] ARM: ux500: Pass MSP DMA platform data though AUXDATA
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It isn't currently possible to pass all platform specific configuration
> though Device Tree. Thinks like device names used in the clock
> infrastructure, call-backs and DMA information have to be passed in via
> AUXDATA structures and the MSP is no exception. Here we're passing DMA
> settings.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
