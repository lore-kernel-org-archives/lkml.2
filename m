Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1JXMUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:20:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43361 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932166Ab1JXMUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:20:19 -0400
Date: Mon, 24 Oct 2011 14:20:15 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Message-ID: <20111024122015.GA26033@opensource.wolfsonmicro.com>
References: <70D251FDDC55405882A8447CC455D56E@hacdom.okisemi.com>
 <8486F61FC3B94B908BFE654234DD6C97@hacdom.okisemi.com>
 <4E9BAEF7.1080406@dsn.lapis-semi.com>
 <s5h7h3ysa4l.wl%tiwai@suse.de>
 <4EA5563A.10703@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA5563A.10703@dsn.lapis-semi.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 09:12:42PM +0900, Tomoya MORINAGA wrote:

> 1. PCI interface function.
> Any current ASoC drivers don't have PCI interface function.
> So I don't know where the function should be in machine driver or
> platform driver.

It depends on what the driver is for.  Probably you want a driver which
is some combination of machine driver and the various drivers that are
normally part of the SoC - whatever roles in the system are filled by
this hardware the driver ought to register subsystem drivers for those
roles.

> 2. Register Access
> Can platform driver access register ?
> According to the soc document, platform driver must not access hardware,
> however, some drivers looks accessing their hardware.

What makes you say this?  A driver that can't access hardware would be
rather useless...
