Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0E1Md0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:33:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36016 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0E1MdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:33:23 -0400
Message-ID: <4BFFB7DD.2080806@ru.mvista.com>
Date: Fri, 28 May 2010 16:32:29 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rupjyoti Sarmah <rsarmah@amcc.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rsarmah@appliedmicro.com, sr@denx.de, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH]Device tree update for the 460ex DWC SATA
References: <201005281215.o4SCFKNi025548@amcc.com>
In-Reply-To: <201005281215.o4SCFKNi025548@amcc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rupjyoti Sarmah wrote:

> Device tree update for the Applied micro processor 460ex on-chip SATA.

> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>

[...]

> diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> index cd56bb5..d3b2c99 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -163,6 +163,14 @@
>  			interrupts = <0x1e 4>;
>  		};
>  
> +		SATA0: sata@bffd1000 {
> +                        compatible = "amcc,sata-460ex";
> +			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
> +                        interrupt-parent = <&UIC3>;
> +                        interrupts = <0x0 0x4       /* SATA */
> +                                      0x5 0x4>;     /* AHBDMA */

    Please indent only using tabs consistently.

WBR, Sergei
