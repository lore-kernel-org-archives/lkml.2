Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab2IGM3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:29:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386Ab2IGM3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:29:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 04/19] ARM: ux500: Add SDI (MMC) support to the HREF Device Tree
Date: Fri, 7 Sep 2012 12:29:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <1347016499-29354-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1347016499-29354-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071229.32027.arnd@arndb.de>
X-Provags-ID: V02:K0:fjyhRj0ekD6GKZRNOK9fUcVQKAv9wy3a55++DRmuv9/
 lm7aiWZFJgUoTPTmkgN6y5LSCAXQOXuXVy333Fp8J6ZtEAeZS6
 aJkpMGychiFwgMxj58MyIvKXrzWfooweU/KKApSxS+KeC3825c
 Q6+Q+/016gxz9Dk9kH2ZujektlUrb8Rs1xsJnT0Qn/GOq/8oPG
 Y/00PypPJI3wf8/eNQjIvGgzJtS8xAihZsmk9niRtVTCtYiMO8
 23Ef/vcrJBAINmVmktrX4LIB3nux7jDes84OpOSIJqP6AeRTu+
 zniHQUdfeNhD4RkBOTPpPLrUfNL4CDx8ew7TMvkXNYepLeOtbw
 GfvfzGuoVP93T9emp9bg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> +               // External Micro SD slot
> +               sdi@80126000 {
> +                       arm,primecell-periphid = <0x10480180>;
> +                       max-frequency = <50000000>;
> +                       bus-width = <8>;
> +                       mmc-cap-sd-highspeed;
> +                       mmc-cap-mmc-highspeed;
> +                       vmmc-supply = <&ab8500_ldo_aux3_reg>;
> +
> +                       #gpio-cells = <1>;
> +                       cd-gpios  = <&gpio2 31 0x4>; // 95
> +
> +                       status = "okay";
> +               };
> +

The #gpio-cells property seems misplaced here.

	Arnd
