Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1JBUlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:41:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53423 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab1JBUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:41:09 -0400
Date: Sun, 2 Oct 2011 21:41:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Message-ID: <20111002204106.GB5811@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317587284-2776-3-git-send-email-arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 10:28:00PM +0200, Arnd Bergmann wrote:
> This driver only builds correctly on platforms that use
> GPIOLIB. Disable it otherwise.

No, gpiolib is one implementation of the GPIO API but if platforms want
to go and define their own that's currently OK (personally I think at
this point we should just be converting all the stragglers over to
gpiolib).  As things stand we shouldn't have dependencies on a
particular implementation of the API.
