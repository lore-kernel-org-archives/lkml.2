Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2HNLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:16:58 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56784 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2HNLQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-17-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-17-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:16:57 +0200
Message-ID: <CACRpkdaGN3nh03sqvTic8oNXPmQisURJVx3nFZm7scuFzonN2A@mail.gmail.com>
Subject: Re: [PATCH 16/22] ARM: ux500: Stop registering the PCM driver from
 platform code
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

> We now initialise the PCM driver through the MSP DAI, so there is
> no need to register it though platform code anymore. This patch
> strips out all PCM platform registration.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
