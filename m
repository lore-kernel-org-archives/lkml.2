Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0D0Ubo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:31:44 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:39379 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab0D0Ubn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:31:43 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Alessandro Rubini <rubini@unipv.it>
Date: Tue, 27 Apr 2010 22:07:37 +0200
Subject: RE: [PATCH] DMAENGINE: DMA40 U8500 platform configuration v4
Thread-Topic: [PATCH] DMAENGINE: DMA40 U8500 platform configuration v4
Thread-Index: AcrmPTd6nhSPjRzUTeybJdj3WevEPAAB+0DQ
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A4964A5@EXDCVYMBSTM006.EQ1STM.local>
References: <1272395344-744-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1272395344-744-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Self]

> This completes the DMA40 support with the platform-specific
> configuration for U8500/DB8500.
(...)
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -137,7 +137,7 @@ static void __init u8500_init_machine(void)
>  	u8500_init_devices();
>  }
> 
> -MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
> +MACHINE_START(NOMADIK, "ST-Ericsson MOP500 platform")

Oh no, I shouldn't touch that. Will fix this...

Yours,
Linus Walleij
