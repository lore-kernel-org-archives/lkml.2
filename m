Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab0GPJgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:36:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36395 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936126Ab0GPJga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:36:30 -0400
Date: Fri, 16 Jul 2010 10:36:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Margarita Olaya Cabrera <magi.olaya@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] twl6040: fix wrong kfree in twl6040_remove and
	twl6040_codec_remove
Message-ID: <20100716093625.GD18376@sirena.org.uk>
References: <1279272408.2594.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279272408.2594.1.camel@mola>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 05:26:48PM +0800, Axel Lin wrote:
> Memory allocation part:
> We allocate a memory in twl6040_codec_probe():
>         priv = kzalloc(sizeof(struct twl6040_data), GFP_KERNEL);
>         twl6040_codec = codec = &priv->codec;

Could you please try to take on board the feedback you were given
yesterday about this sort of stuff?  Both the feedback about formatting
your patch so it's easy to apply and the collisions with other, more
substantial, work that's going on?
