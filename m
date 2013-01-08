Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3AHVWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:22:47 -0500
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:35241 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031Ab3AHVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:22:46 -0500
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 16:22:46 EST
Date: Tue, 8 Jan 2013 21:01:49 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        JM.Lin@atmel.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [v3 PATCH 9/9] ARM: dts: add the watchdog nodes for
 at91sam9g25ek boards
Message-ID: <20130108200149.GE7360@game.jcrosoft.org>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
 <1357353529-20901-10-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357353529-20901-10-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8900238765028518789
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:38 Sat 05 Jan     , Wenyou Yang wrote:
> Tested on the at91sam9g25ek boards
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: linux@arm.linux.org.uk
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/at91sam9x5ek.dtsi |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> index 8a7cf1d..afddf75 100644
> --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> @@ -69,6 +69,10 @@
>  				status = "okay";
>  			};
>  
> +			watchdog@fffffe40 {
> +				status = "okay";
> +			};
> +

use less today as the watchdog is shutdown at bootstrap level

and on at91 once shutdown we can not enable it again

Best Regards,
J.
>  			pinctrl@fffff400 {
>  				mmc0 {
>  					pinctrl_board_mmc0: mmc0-board {
> -- 
> 1.7.9.5
> 
