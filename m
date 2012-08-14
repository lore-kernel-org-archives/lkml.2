Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2HNIkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:40:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35077 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2HNIkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <1344527268-5964-4-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
	<1344527268-5964-4-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 Aug 2012 10:40:46 +0200
Message-ID: <CACRpkdY9L_-RwV6xWV9ta+qubWce0ZH0+FXaCHkeaWRvSYUhKQ@mail.gmail.com>
Subject: Re: [PATCH 03/22] ASoC: ab8500: Inform SoC Core that we have our own
 I/O arrangements
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If codec->control_data is not populated SoC Core assumes we want to
> use regmap, which fails catastrophically, as we don't have one:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000080
> pgd = c0004000
> [00000080] *pgd=00000000
> Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> Modules linked in:
> CPU: 1    Not tainted  (3.5.0-rc6-00884-g0b2419e-dirty #130)
> PC is at regmap_read+0x10/0x5c
> LR is at hw_read+0x80/0x90
> pc : [<c01a91b8>]    lr : [<c0216804>]    psr: 60000013
>
> CC: alsa-devel@alsa-project.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

No clue on this one, have to refer to Mark...

Linus Walleij
