Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1JBUyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:54:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JBUy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:54:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Date: Sun, 02 Oct 2011 22:53:24 +0200
Message-ID: <2726393.3Oc3SrGyN4@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002204106.GB5811@opensource.wolfsonmicro.com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <1317587284-2776-3-git-send-email-arnd@arndb.de> <20111002204106.GB5811@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o7DBiejncW0/tEECXUD9wEDpMVep40tG7XwcPdgVIw+
 5NfGqOOB0O21g/Y8fDfI+3POiIjTxPveVvGBxdWA/g22KZHFg7
 QdEBpU4ECmX74bXvZuRPyGYoGQ2EyXtm1CcNT7OIHJpXc4zIoo
 bZH4G3WPx6lF9jJ+BLY6FdEn9GQNbpn+in5lxOPl5qi9JS8KFn
 T1BETSILKhdTCkMynuJp9yaN11P7f6ZsXgWp2JWuMIi+AYOUCL
 NSaNRQV9tC/6KG/Vk4Myus4MqXX2g920MDeFl35lgL7BHZ1ZVH
 vJtwULN2EormQ7B5WMDEheBFGK00Rqzpch6Q60lUMDgLsEPaLz
 rl6aHrC8KEtRPBbrASns=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 21:41:07 Mark Brown wrote:
> On Sun, Oct 02, 2011 at 10:28:00PM +0200, Arnd Bergmann wrote:
> > This driver only builds correctly on platforms that use
> > GPIOLIB. Disable it otherwise.
> 
> No, gpiolib is one implementation of the GPIO API but if platforms want
> to go and define their own that's currently OK (personally I think at
> this point we should just be converting all the stragglers over to
> gpiolib).  As things stand we shouldn't have dependencies on a
> particular implementation of the API.

Thanks for the explanation!

Is there any other symbol that I can test then?

I noticed that a lot of places use 'depends on GPIOLIB' or
'#ifdef CONFIG_GPIOLIB', are those usually wrong, too?

	Arnd
