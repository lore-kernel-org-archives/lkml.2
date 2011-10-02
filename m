Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1JBRk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 13:40:56 -0400
Received: from bitmer.com ([213.157.87.50]:33762 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1JBRkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 13:40:49 -0400
Date: Sun, 2 Oct 2011 20:40:35 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 21/30] sound/soc/omap: limit to omap2plus
Message-Id: <20111002204035.2e5b98943ed5137fd689b9be@bitmer.com>
In-Reply-To: <1317566760-25681-22-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
	<1317566760-25681-22-git-send-email-arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Oct 2011 16:45:51 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> These drivers do not build correctly on omap1, so only allow
> selecting them on omap2 or higher.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
> Cc: Liam Girdwood <lrg@ti.com>
> ---
Strange. I'm able to build them fine with omap1_defconfig and with two
supported OMAP1 ASoC machine drivers we have:

CONFIG_SND_OMAP_SOC_AMS_DELTA=y
CONFIG_SND_OMAP_SOC_OSK5912=y

What's the error you are seeing? I guess there might be some missing
dependency that doesn't get visible with omap1_defconfig.

I would like to get that fixed instead of disabling OMAP1 ASoC support
as the ams-delta in kernel is alive device thanks to active developer
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>.

-- 
Jarkko
