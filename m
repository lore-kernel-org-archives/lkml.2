Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1JCPUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:20:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60764 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756413Ab1JCPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:20:04 -0400
Date: Mon, 3 Oct 2011 16:20:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, Dmitry Artamonow <mad_soft@inbox.ru>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Message-ID: <20111003152002.GP3731@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <20111003134527.GF11710@n2100.arm.linux.org.uk>
 <20111003143553.GG23811@sirena.org.uk>
 <1343003.MpQlxoEPa6@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343003.MpQlxoEPa6@wuerfel>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:47:07PM +0200, Arnd Bergmann wrote:

> sound/soc/codecs/wm1250-ev1.c:32:14: error: array type has incomplete element type

OK, that's the gpio_request_ stuff not being implemented thing that I
have seen some reports of.  Looks like that's not been stubbed out, but
for Prima2 the best fix is just to turn on gpiolib since there's no
excuse for a new platform to not use it.
