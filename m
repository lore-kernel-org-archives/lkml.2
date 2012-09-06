Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2IFH4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:56:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51332 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab2IFH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:56:03 -0400
Date: Thu, 6 Sep 2012 15:36:35 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: ams-delta: fix card initalization
 failure
Message-ID: <20120906073633.GC22330@opensource.wolfsonmicro.com>
References: <1346102910-8610-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1809544.cvZPIRmRr5@acer>
 <20120831213103.GC5495@opensource.wolfsonmicro.com>
 <1939338.OUN9Uq58XY@vclass>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1939338.OUN9Uq58XY@vclass>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 11:09:18AM +0200, Janusz Krzysztofik wrote:

> I see your point, however for now I can see no better way of referencing 
> the data (of type struct snd_soc_card) then passing it to 
> snd_soc_register_card(). But for this to work, I would have to register 
> successfully an ams-delta specific platform device first, not the soc-
> audio. This, even if still done from the sound/soc/omap/ams-delta.c, not 
> from an arch board file, would require now not existing ams-delta ASoC 
> platform driver probe/remove callbacks at least. I'm still not convinced 
> if such modification would be acceptable in the middle of the rc cycle.

> If there is a simpler, less intrusive way to do this, then sorry, I 
> still can't see it.

Like I already said just make it a static variable.
