Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2KZIuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:50:07 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:53618 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2KZIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:50:05 -0500
Message-ID: <20659.11566.624414.569253@ipc1.ka-ro>
Date: Mon, 26 Nov 2012 09:49:50 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ASoC: mxs-saif: export
 mxs_saif_put_mclk,mxs_saif_get_mclk
In-Reply-To: <20121123144541.GT4529@opensource.wolfsonmicro.com>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
	<1353587470-11994-4-git-send-email-LW@KARO-electronics.de>
	<20121123020635.GK4385@opensource.wolfsonmicro.com>
	<20655.9202.288388.343758@ipc1.ka-ro>
	<20121123144541.GT4529@opensource.wolfsonmicro.com>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown writes:
> On Fri, Nov 23, 2012 at 08:21:22AM +0100, Lothar Waßmann wrote:
> > > On Thu, Nov 22, 2012 at 01:31:09PM +0100, Lothar Waßmann wrote:
> 
> > > Why?
> 
> > I thought that was obvious... To be able to compile the mxs sound
> > driver as module.
> 
> Do you want to add new users of these functions, or are there existing
> users which currently fail to link when built as modules?
>
The existing MXS sound driver fails to build as module
(CONFIG_SND_SOC_MXS_SGTL5000=m) without this patch.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
