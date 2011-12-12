Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1LLG4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:56:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38572 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1LLG4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:56:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111209122457.GA29492@opensource.wolfsonmicro.com>
References: <1323428632-29309-1-git-send-email-tomoya.rohm@gmail.com>
	<20111209122457.GA29492@opensource.wolfsonmicro.com>
Date: Mon, 12 Dec 2011 15:56:47 +0900
Message-ID: <CANKRQnj+x=QDgAoAi7MBq9Kjvin8kO8OjMrDJSZFW5+4Mz89pQ@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/lapis: add machine driver v3 updated
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/9 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Dec 09, 2011 at 08:03:52PM +0900, Tomoya MORINAGA wrote:
> Otherwise this looks good, though obviously there's a dependency on the
> CPU drivers.

I just started developing plat form driver.
According to platform.txt, soc/pxa/pxa2xx-pcm.c is shown as example.
Can I believes this description ?
If the driver is not modern, let me know the modern platform driver.

Thanks in advance.

tomoya
