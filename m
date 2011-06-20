Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1FTNGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:06:50 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58200 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab1FTNGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:06:47 -0400
Subject: Re: [PATCH 2/2] video: omap2: Compile omap2 support only when
 needed
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, tony@atomide.com, lethal@linux-sh.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
In-Reply-To: <1308566761-2850-3-git-send-email-tushar.behera@linaro.org>
References: <1308566761-2850-1-git-send-email-tushar.behera@linaro.org>
	 <1308566761-2850-3-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 16:06:41 +0300
Message-ID: <1308575201.2076.57.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 16:16 +0530, Tushar Behera wrote:
> Currently display support for omap2 is selected by default and
> it gets built for all the configurations.
> 
> Instead of it being a built-in feature, it's compilation should
> depend on the config option CONFIG_FB_OMAP2.

No, I don't think so. omap2 directory contains vram, vrfb and omapdss,
all of which can be used without omapfb driver. vram and vrfb can be
even used without omapdss driver.

Is this patch fixing some real problem?

 Tomi


