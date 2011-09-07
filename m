Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1IGRNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:13:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51869 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751618Ab1IGRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:13:01 -0400
Date: Wed, 7 Sep 2011 10:12:56 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>, Geoff Levand <geoff@infradead.org>,
        Liam Girdwood <lrg@ti.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Joe Perches <joe@perches.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jhnikula@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, Simon Horman <simon@horms.net>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 60/62] sound: irq: Remove IRQF_DISABLED
Message-ID: <20110907171256.GB2906@opensource.wolfsonmicro.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-61-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-61-git-send-email-yong.zhang0@gmail.com>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:10:57PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
