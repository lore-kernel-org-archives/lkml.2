Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2IJPYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:24:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61701 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2IJPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120910161428.879618aea62e5be6340ed93c@canb.auug.org.au>
References: <20120910161428.879618aea62e5be6340ed93c@canb.auug.org.au>
Date: Mon, 10 Sep 2012 08:24:49 -0700
Message-ID: <CACRpkdbf94QG59pvqcN_grCG_tcpri7JyypZ9ZMu3R=LwvSoXw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the clk tree with the arm-soc tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Turquette <mturquette@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Loic PALLARDY <loic.pallardy@st.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 8:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the clk tree got a conflict in
> arch/arm/mach-ux500/clock.c between commit 79964bcd792f ("ARM: ux500:
> Correct Ux500 family names usage") from the arm-soc tree and commit
> ebc96db7632f ("ARM: ux500: Switch to use common clock framework") from
> the clk tree.
>
> The latter removed the file so I did that - there may be more fixup
> required.

This is the correct solution, thanks!

Yours,
Linus Walleij
