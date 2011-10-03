Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1JCNqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:46:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57301 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab1JCNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:45:59 -0400
Date: Mon, 3 Oct 2011 14:45:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Message-ID: <20111003134527.GF11710@n2100.arm.linux.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <1317587284-2776-3-git-send-email-arnd@arndb.de> <20111002204106.GB5811@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002204106.GB5811@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 09:41:07PM +0100, Mark Brown wrote:
> On Sun, Oct 02, 2011 at 10:28:00PM +0200, Arnd Bergmann wrote:
> > This driver only builds correctly on platforms that use
> > GPIOLIB. Disable it otherwise.
> 
> No, gpiolib is one implementation of the GPIO API but if platforms want
> to go and define their own that's currently OK (personally I think at
> this point we should just be converting all the stragglers over to
> gpiolib).  As things stand we shouldn't have dependencies on a
> particular implementation of the API.

Then it should depend on GENERIC_GPIO (not to be confused with GPIO_GENERIC,
the generic gpiolib driver), which is the symbol meaning that the GPIO API
is provided by something.
