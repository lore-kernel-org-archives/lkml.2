Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1FBM50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:57:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46587 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1FBM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:57:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.miao@linaro.org>, Eric Miao <eric.miao@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: fix the menuconfig being wrongly displayed
In-Reply-To: Your message of "Thu, 02 Jun 2011 13:09:14 +0800."
             <1306991354-11890-1-git-send-email-eric.y.miao@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1306991354-11890-1-git-send-email-eric.y.miao@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1307019429_2630P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jun 2011 08:57:09 -0400
Message-ID: <33745.1307019429@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DE788A8.002F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1307019429_2630P
Content-Type: text/plain; charset=us-ascii

On Thu, 02 Jun 2011 13:09:14 +0800, Eric Miao said:
> From: Eric Miao <eric.miao@canonical.com>
> 
> Seems when a config option does not have a dependency of the menuconfig,
> it messes the display of the rest configs, even if it's a hidden one.
> 
> Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 23f0d5e..7066820 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -7,6 +7,8 @@ menuconfig NEW_LEDS
>  	  This is not related to standard keyboard LEDs which are controlled
>  	  via the input system.
>  
> +if NEW_LEDS
> +
>  config LEDS_CLASS
>  	bool "LED Class Support"
>  	depends on NEW_LEDS

Having added that 'if', do we still need that 'depends'?

--==_Exmh_1307019429_2630P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN54ikcC3lWbTT17ARAmFxAJ4yX1T7+aHRpmnLeEP0n6UqkwPw/wCcDEn7
mrPFuTymLjDCWwUaCDRYKCQ=
=71Gr
-----END PGP SIGNATURE-----

--==_Exmh_1307019429_2630P--

