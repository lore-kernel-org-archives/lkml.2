Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2HNLQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:16:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57100 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2HNLQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:16:17 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-16-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-16-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:16:16 +0200
Message-ID: <CACRpkdabmQaQeSuwoBY7DxvSOyPDRWvSBDm+Yn-fJP5eWybuMQ@mail.gmail.com>
Subject: Re: [PATCH 15/22] ARM: ux500: Stop registering the MOP500 Audio
 driver from platform code
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

> In this patch we prevent MOP500 driver registration from platform
> code and rely solely on Device Tree to do the probing for us.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
