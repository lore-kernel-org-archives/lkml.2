Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1HPNJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:09:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1HPNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:09:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Tue, 16 Aug 2011 15:09:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161509.17157.arnd@arndb.de>
X-Provags-ID: V02:K0:3i+s/IBAOQPzQibGMcGUaHmXHVK1uASIm3n1qcPgDsw
 5IosUWAAMH4Q0v71T5wCArg8JNYDk95s0HiKDZaxYbGRnFe/z7
 VlAhQ3ibhoTopklqI1Ficr8tnKNQrmMPhCvHhw1m6/siHgO+EQ
 45EXakoxDkosmjvZFU6JdJlhRRGL/9Our4wby6zzLUKTsakwO+
 tmvAoW0GyXPbvElS1dAGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 August 2011, Stephen Warren wrote:
> v2:
> * Enhanced pinmux code to handle "drive pingroups" as well as "mux
>   pingroups". This altered the pinmux binding a little; shifting each
>   type of pingroup into a sub-node in the pinmux node.
> * Enumerate pingroups by enumerating DT child nodes, and mapping them to
>   pingroups, rather than the other way around. Hence also removed
>   modifications to <linux/of.h> and drivers/of/base.c.
> * Included documentation of the bindings.
> * Represent pingroup names and function names, as lower case in DT.
> * Used a better name for GPIO binding GPIO list.
> * Switched to boolean properties for pinmux pull-up/down.
> * s/dev_err/dev_dbg/ in DT parsing debug code.
> * Various minor cleanups (e.g. typos, white-space).
> 
> This patch modifies Tegra's device tree support to remove the dependency
> on harmony_pinmux_init(), thus making it completely board-independent.

I don't understand enough of the technical background to comment on
the contents, on the surface it all makes sense.

I do think that you should keep Linus Walleij on Cc in these emails, since
he first started pushing for a common pinmux layer, and we need to make
sure that the binding works for all SoCs, not just for tegra.

	Arnd
