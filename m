Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1HOFvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:51:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38376 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1HOFvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:51:06 -0400
Subject: [linux-next] ASoC: sound/soc/davinci/davinci-sffsdr.c build failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hugo Villeneuve <hugo@hugovil.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 13:50:58 +0800
Message-ID: <1313387458.25484.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build test with "davinci_all_defconfig" + enable SND_DAVINCI_SOC_SFFSDR.
I got below build error:

  CC [M]  sound/soc/davinci/davinci-sffsdr.o
sound/soc/davinci/davinci-sffsdr.c:118: error: 'DAVINCI_MCBSP_BASE' undeclared here (not in a function)
sound/soc/davinci/davinci-sffsdr.c:124: error: variable 'sffsdr_snd_data' has initializer but incomplete type
sound/soc/davinci/davinci-sffsdr.c:125: error: unknown field 'tx_dma_ch' specified in initializer
sound/soc/davinci/davinci-sffsdr.c:125: warning: excess elements in struct initializer
sound/soc/davinci/davinci-sffsdr.c:125: warning: (near initialization for 'sffsdr_snd_data')
sound/soc/davinci/davinci-sffsdr.c:126: error: unknown field 'rx_dma_ch' specified in initializer
sound/soc/davinci/davinci-sffsdr.c:126: warning: excess elements in struct initializer
sound/soc/davinci/davinci-sffsdr.c:126: warning: (near initialization for 'sffsdr_snd_data')
sound/soc/davinci/davinci-sffsdr.c: In function 'sffsdr_init':
sound/soc/davinci/davinci-sffsdr.c:148: error: invalid application of 'sizeof' to incomplete type 'struct evm_snd_platform_data' 
make[3]: *** [sound/soc/davinci/davinci-sffsdr.o] Error 1
make[2]: *** [sound/soc/davinci] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2


