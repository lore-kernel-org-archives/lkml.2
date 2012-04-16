Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2DPDqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:46:43 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61871 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2DPDqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:46:42 -0400
Date: Mon, 16 Apr 2012 11:46:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Dong Aisheng <dongas86@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120416034646.GI24997@S2101-09.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <20120414134814.GA3852@pengutronix.de>
 <CAA+hA=T0FAfuGKcW0vAKO+OWyFdM-6vQqVo53xKf8y28m7gPOQ@mail.gmail.com>
 <20120415141736.GG24997@S2101-09.ap.freescale.net>
 <20120416034713.GB17173@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416034713.GB17173@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:47:14AM +0800, Dong Aisheng wrote:
...
> Good suggestion.
> I can do it and it's easy to change.
> But as i said above, before the dtc macro support is available, the pinctrl
> setting in dts file will be hard to read since it's all raw data.
> It becomes
> fsl,pins = <1 2 3 4 5 6 ....>;
> People have to search the binding doc to see what the data means.
> 
It does not make the thing any worse.  You were asking people to search
pinctrl-imx6q.c for the meaning of the following.

  fsl,mux = <0 0 1 1 1 1 1 1 1 1>;

IMO, it makes a bit more sense to look at binding doc than code to
understand the dts file.

> The question is how long the dtc macro support will be available?
> I'm very willing to do like as you said if it's just a short time.
> But if it's long time, do we still want to lose the readability right now?
> 
The point is with my suggestion taken, we do not need to change code
when the dtc macro support is available.

-- 
Regards,
Shawn
