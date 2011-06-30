Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1F3Lms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:42:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1F3Lmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:42:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 3/3] pwm: Add a i.MX23/28 pwm driver
Date: Thu, 30 Jun 2011 13:42:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>
References: <1309430517-23821-1-git-send-email-s.hauer@pengutronix.de> <1309430517-23821-4-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1309430517-23821-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301342.36088.arnd@arndb.de>
X-Provags-ID: V02:K0:lt0SwOsmY4qIHYAM96sADkOFVxTBqZt71DSvBNJqCJR
 Rn/cNZP/4//fFjUW05zn6hc0aPICO8LA8sLx04j1mawWpirQ0m
 TIPbLEvpiFtw7mCo3VErs2Bf/pXDfrSDJ4wAlGIsptY0gyE006
 v1Pnn0nCfTeIziub44QK4jv6LkuY9W2Z0SP1THxrCPnLCd5Ze1
 adYZbHiTwm9dZN2gfbgoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011, Sascha Hauer wrote:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Hi Sascha,

The probing looks good to me now. I would have added extra code to avoid
ioremapping the same page multiple times, but I see this as a matter of
different preferences, so I'm fine with that.

You are still missing a description of the driver, both in the changelog
above and in the Kconfig patch. A small sentence to spell out PWM
in the changelog and to list the devices that will use this driver
would be helpful to the causal reader.

Provided that you add that:

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 93c1052..5694574 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -2,11 +2,15 @@ menuconfig PWM
>  	bool "PWM Support"
>  	help
>  	  This enables PWM support through the generic PWM framework.
> -	  You only need to enable this, if you also want to enable
> +	  You only need to enable this if you also want to enable
>  	  one or more of the PWM drivers below.
>  
>  	  If unsure, say N.
>  

I think this hunk should have been in the other first patch.

	Arnd
