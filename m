Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2GXTZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:25:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2GXTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:25:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH] ARM: vt8500: clk: Add clock support for arch-vt8500
Date: Tue, 24 Jul 2012 19:25:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Alexey Charkov <alchark@gmail.com>
References: <1342969400-21123-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1342969400-21123-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241925.02594.arnd@arndb.de>
X-Provags-ID: V02:K0:8ae1aFaz4bLySWMSzLynNyHuXM/NYzNoFl7ZWKXZUaB
 3vT2nOq608ZjobtJaFRAJjXsobj58CTVM4ENs+Uk4xmid/yl7Z
 Zn4VLeSRrdBoEIFSCR57kFg3wqFnir6MqoINLsz26NSQpCPqwR
 wTs1hAuOV2M+1MgnAJ+oFTAyeD7nrA4LsHQZxe2VoatPyugrMN
 1Ofjfb3Uz1Tbu1/DJRcbBHPzisLRIOTUOonPYye0oITujJyFJI
 6cx6IYoR2kkGYOealo9h24Auy9IZirCf0/CpZjKVHwqzFZP740
 kiUHLN5W0fw9k/ahJCbfTYuPEvZcdXtdXSY6xIVkZf82ZuXP6f
 Zc4ihP2eYDdeM3+YFs5Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2012, Tony Prisk wrote:
> 
> This patch adds common clock framework support for arch-vt8500.
> WM8650 support is included in preparation for devicetree support.
> Each SoC has a seperate initialization function due to no
> devicetree support to identify SoCs at the moment. Once devicetree
> is implemented, VT8500 and WM8505 should be combined. WM8650 uses
> different functions for clocks.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

arch/arm parts:

Acked-by: Arnd Bergmann <arnd@arndb.de>
