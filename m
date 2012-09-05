Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2IEKmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:42:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2IEKmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:42:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/17] arm: ux500: add ccu9540 board support
Date: Wed, 5 Sep 2012 10:42:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "LT ST-Ericsson" <st-ericsson@lists.linaro.org>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com> <1346839153-6465-3-git-send-email-loic.pallardy-ext@stericsson.com>
In-Reply-To: <1346839153-6465-3-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051042.00887.arnd@arndb.de>
X-Provags-ID: V02:K0:TerDWZYPgNEzWJYDA5XGqm8stJKTP1lYQJaDV8PjqWd
 7PyaznkN+3cRO/dHswq7fJBcOs4+msHSlByjQviv/wSWsQkEiX
 oTT+t6xgxmlp+ZtWmx1fRi5Yio/Z6hBVaUnM0Xb0ljpMCD+9Tc
 KyCNes0p9CDCeNa2MaZ4JFofizfnHACYYKGjFsctAfC5UQ1/6e
 HIrbKLyWF6Qq0NjL1ns+BK3mi2OMGaGsf2o/INl0ebOCDp4Vao
 WZ3WYM2YsHebraOoPXgjtY3mbrhBp080HthR8kGNSOj2aUgc/y
 g8oiAVPkysvh957lPL94tuPXW/rGsN7/MDUR1r9V5CulQRHp8N
 liQPJgsiiOUBbTbEQAMw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012, Loic Pallardy wrote:
> +MACHINE_START(U9540, "ST-Ericsson 9540 platform")
> +       .atag_offset    = 0x100,
> +       .map_io         = u8500_map_io,
> +       .nr_irqs        = UX500_NR_IRQS,
> +       .init_irq       = ux500_init_irq,
> +       .timer          = &ux500_timer,
> +       .handle_irq     = gic_handle_irq,
> +       .init_machine   = u9540_init_machine,
> +       .init_late      = ux500_init_late,
> +MACHINE_END
> +

Please don't add another ATAG based board definition to ux500. We're closing in
on having full support for DT booting with this platform, so your patch is just
making it harder for us to complete this. 

	Arnd
