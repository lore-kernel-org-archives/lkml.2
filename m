Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0GAPDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:03:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52727 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756755Ab0GAPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:03:12 -0400
Date: Thu, 1 Jul 2010 16:03:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Raffaele Recalcati <raffaele.recalcati@bticino.it>,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/3] ASoC: DaVinci: Added fast clock timing for McBSP
 (I2S)
Message-ID: <20100701150310.GF8742@rakim.wolfsonmicro.main>
References: <1277905678-4695-1-git-send-email-lamiaposta71@gmail.com>
 <1277905678-4695-4-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277905678-4695-4-git-send-email-lamiaposta71@gmail.com>
X-Cookie: Sign my PETITION.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 03:47:58PM +0200, Raffaele Recalcati wrote:
> From: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> 
>     i2s_fast_clock switch can be used to have a better approximate

Oh, and please look at the CC list for these posts.  You're CCing *very*
widely and at least one address (chaithrika@ti.com) actually bounces.
