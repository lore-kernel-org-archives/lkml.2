Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412Ab2JaLHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:07:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52167 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab2JaLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:07:35 -0400
Message-ID: <50910664.1010304@ti.com>
Date: Wed, 31 Oct 2012 12:07:16 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, AnilKumar Ch <anilkumar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: am33xx: rtc node
References: <1351589646-27082-1-git-send-email-afzal@ti.com>
In-Reply-To: <1351589646-27082-1-git-send-email-afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Afzal,

On 10/30/2012 10:34 AM, Afzal Mohammed wrote:
> Add am33xx rtc node.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
> Hi Benoit,
> 
> This is based on your for_3.8/dts branch.

I've just applied it in the branch with a slight change in the subject.

Thanks,
Benoit

> 
> This has been tested on Beagle Bone.
> 
> Bindings along with driver changes for DT has been picked by Andrew
> Morton and is now present in linux-next.
> 
> Regards
> Afzal
> 
> v2
>  1. Remove interrupt parent in rtc node.
>  2. Modify subject as per new convention.
> 
> 
>  arch/arm/boot/dts/am33xx.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 70d24b8..97a7bd3 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -291,5 +291,13 @@
>  			ti,hwmods = "timer7";
>  			ti,timer-pwm;
>  		};
> +
> +		rtc@44e3e000 {
> +			compatible = "ti,da830-rtc";
> +			reg = <0x44e3e000 0x1000>;
> +			interrupts = <75
> +				      76>;
> +			ti,hwmods = "rtc";
> +		};
>  	};
>  };
> 

