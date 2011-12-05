Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1LESZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:25:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1LESZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:25:42 -0500
Date: Mon, 5 Dec 2011 18:25:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v2] soc/lapis: add machine driver
Message-ID: <20111205182540.GA7467@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
 <20111202153401.GX8245@opensource.wolfsonmicro.com>
 <CANKRQngGHLD0Bam6sxCGPSkGutjkagbJMvGPTgkduXR6xmMw_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQngGHLD0Bam6sxCGPSkGutjkagbJMvGPTgkduXR6xmMw_Q@mail.gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 02:28:29PM +0900, Tomoya MORINAGA wrote:

> According to "machine.txt", I created this machine driver referring
> corgi.c/spitz.c.
> However, corgi.c/spitz.c. don't look obeying your saying.

You really need to look at current drivers to make sure you're following
current best practice - older drivers, particularly for obsolte hardware
like the Zaurus machines, may well not reflect the current best practices.
