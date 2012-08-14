Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2HNLX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:23:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35081 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HNLXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-22-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-22-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 13:23:54 +0200
Message-ID: <CACRpkdZzq_zrC247iFFf4UE-5hXZzTxZwqqDTDy6j2ez4ArfEw@mail.gmail.com>
Subject: Re: [PATCH 21/22] ARM: ux500: Add all encompassing sound node to the
 Snowball Device Tree
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

> This is where we link together all of the SoC sound components for
> a given platform. This all encompassing sound node is only found
> in the very lowest hierarchical DTS file, since the component mix may
> well change from board variant to board variant.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
