Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2GYLVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:21:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34267 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab2GYLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:21:51 -0400
Message-ID: <500FD698.30906@mvista.com>
Date: Wed, 25 Jul 2012 15:20:56 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, nsekhar@ti.com, khilman@ti.com,
        a.zummo@towertech.it, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v2 6/6] arm/dts: am33xx rtc node
References: <cover.1343191280.git.afzal@ti.com> <d16976055462214af276d7242faa2bc6e621fd44.1343191280.git.afzal@ti.com>
In-Reply-To: <d16976055462214af276d7242faa2bc6e621fd44.1343191280.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-07-2012 10:12, Afzal Mohammed wrote:

> Add AM33xx rtc node.

> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---

> v2:
>   Use compatible as ti,da830-rtc instead of ti,am1808-rtc

>   arch/arm/boot/dts/am33xx.dtsi |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index bd0cff3..e1ed72d 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -159,5 +159,10 @@
>   			compatible = "ti,omap3-wdt";
>   			ti,hwmods = "wd_timer2";
>   		};
> +
> +		rtc@44e3e000 {

    Address postfix in the node name without "reg" property?

> +			compatible = "ti,da830-rtc";
> +			ti,hwmods = "rtc";
> +		};

WBR, Sergei


