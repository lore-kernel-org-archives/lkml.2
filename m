Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1C3AbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:31:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49986 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605Ab1C3AbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:31:13 -0400
Date: Wed, 30 Mar 2011 09:31:19 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: alsa-devel@alsa-project.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Jarkko Nikula <jhnikula@gmail.com>,
        Timur Tabi <timur@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/soc/pxa/zylonite.c: set .codec_dai_name in
 initializer
Message-ID: <20110330003113.GA2853@opensource.wolfsonmicro.com>
References: <1300448853-15651-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300448853-15651-1-git-send-email-ospite@studenti.unina.it>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:47:33PM +0100, Antonio Ospite wrote:
> Fix the initialization of .codec_dai_name in zylonite_dai initializer,
> do not mix it with the initialization of .codec_name which is set
> already a few lines above.

Applied, thanks.

As discussed via IRC please fix your mail setup so it can deliver to
hosts without MX records.  Please also try to cut down the CC lists a
bit - don't blindly trust get_maintainers.
