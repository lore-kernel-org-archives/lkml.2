Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2IJIrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:47:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38226 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2IJIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:47:11 -0400
MIME-Version: 1.0
In-Reply-To: <1347016499-29354-2-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-2-git-send-email-lee.jones@linaro.org>
Date: Mon, 10 Sep 2012 01:47:09 -0700
Message-ID: <CACRpkdbWVjiqrehj_v7M=cgnytEio5whTXOcax5wo0YSRe=-yA@mail.gmail.com>
Subject: Re: [PATCH 01/19] ARM: ux500: Add skeleton Device Tree for the HREF
 reference board
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:

> First commit applying the new Device Tree for ST-Ericsson's u8500
> based hardware reference board.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

> +/dts-v1/;
> +/include/ "dbx5x0.dtsi"

This include is not even in linux-next, is this patch series dependent
on some other series I have not seen, or that I have forgot that
I saw (and even possibly ACKed...)

Apart from that it looks good.

Yours,
Linus Walleij
