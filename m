Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0KIKG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:06:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55616 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0KIKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:06:55 -0500
Subject: Re: [PATCH] ASoC: Fix compile error if CONFIG_DEBUG_FS is not
 configured
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>
In-Reply-To: <1289293604.28671.5.camel@mola>
References: <1289293604.28671.5.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 10:01:06 +0000
Message-ID: <1289296866.3290.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 17:06 +0800, Axel Lin wrote:
> Add soc_init_card_debugfs and soc_cleanup_card_debugfs functions to fix below error.
> 
>   CC      sound/soc/soc-core.o
> sound/soc/soc-core.c: In function 'soc_probe':
> sound/soc/soc-core.c:1689: error: implicit declaration of function 'soc_init_card_debugfs'
> sound/soc/soc-core.c: In function 'soc_remove':
> sound/soc/soc-core.c:1718: error: implicit declaration of function 'soc_cleanup_card_debugfs'
> make[2]: *** [sound/soc/soc-core.o] Error 1
> make[1]: *** [sound/soc] Error 2
> make: *** [sound] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

