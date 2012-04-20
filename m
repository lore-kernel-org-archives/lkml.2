Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab2DTCHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:07:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41590 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab2DTCHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:07:43 -0400
Date: Fri, 20 Apr 2012 10:08:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Lee <rob.lee@linaro.org>, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120420020816.GH22219@S2101-09.ap.freescale.net>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
 <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
 <20120417074301.GM20478@pengutronix.de>
 <CAMXH7KH41kWMPu_dEpetZc8OUD3C0-mtxGbXX0Vqd4EODPWJUg@mail.gmail.com>
 <20120417174213.GD3852@pengutronix.de>
 <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
 <CAMXH7KGgSmvfqUTC1bufBz0QXbt01dHsPo1cbRA9jLj9mGmfjg@mail.gmail.com>
 <20120419064308.GH3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419064308.GH3852@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 08:43:08AM +0200, Sascha Hauer wrote:
> > Sascha or Shawn, any further comments on my question?
> 
Sorry for the late response, Rob.

> I don't think we need a cpu_is_imx6q(), but having some i.MX6 specific
> hook at device_initcall time can't be too wrong. Shawn?
> 
Yep, it works for me.

-- 
Regards,
Shawn
