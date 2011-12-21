Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1LUSdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:33:52 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33709 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab1LUSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:33:50 -0500
Message-ID: <1324492424.8478.5.camel@odin>
Subject: Re: [PATCH 07/10] ASoC: OMAP: ams-delta: Drive modem/codec pins
 over GPIO API
From: Liam Girdwood <lrg@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 21 Dec 2011 18:33:44 +0000
In-Reply-To: <1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
	 <1323634328-856-8-git-send-email-jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 21:12 +0100, Janusz Krzysztofik wrote:
> Don't use Amstrad Delta custom I/O functions any longer, replace them
> with GPIO. Old pin definitions, no longer used by the modem bits either,
> can be dropped.
> 
> Depends on patch 2/10 "ARM: OMAP1: Convert Amstrad E3 latches to
> basic_mmio_gpio".
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Applied.

Thanks

Liam

