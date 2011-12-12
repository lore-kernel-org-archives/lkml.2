Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1LLG56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:57:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58278 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1LLG55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:57:57 -0500
Date: Mon, 12 Dec 2011 14:57:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v3] sound/soc/lapis: add machine driver v3 updated
Message-ID: <20111212065751.GA20343@opensource.wolfsonmicro.com>
References: <1323428632-29309-1-git-send-email-tomoya.rohm@gmail.com>
 <20111209122457.GA29492@opensource.wolfsonmicro.com>
 <CANKRQnj+x=QDgAoAi7MBq9Kjvin8kO8OjMrDJSZFW5+4Mz89pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnj+x=QDgAoAi7MBq9Kjvin8kO8OjMrDJSZFW5+4Mz89pQ@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 03:56:47PM +0900, Tomoya MORINAGA wrote:

> I just started developing plat form driver.
> According to platform.txt, soc/pxa/pxa2xx-pcm.c is shown as example.
> Can I believes this description ?
> If the driver is not modern, let me know the modern platform driver.

It's pretty old but there's not been many updates in the world of
platform drivers.  In general if you're looking for modern drivers git
log is your friend - look for things that are being actively worked on.
