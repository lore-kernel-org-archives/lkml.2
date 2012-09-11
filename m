Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2IKGjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:39:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36876 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2IKGjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:39:13 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>
Subject: RE: [PATCH v2 0/2] ARM: dts: AM33xx: Correct gpio labels to match
 docs
Thread-Topic: [PATCH v2 0/2] ARM: dts: AM33xx: Correct gpio labels to match
 docs
Thread-Index: AQHNj4ypfMVMfbANNU+uDUag7ONK/JeErUNQ
Date: Tue, 11 Sep 2012 06:38:59 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EAB06D5@DBDE01.ent.ti.com>
References: <1347306312-31533-1-git-send-email-mporter@ti.com>
In-Reply-To: <1347306312-31533-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 01:15:10, Porter, Matt wrote:
> Changes since v1:
> 	- Series now applies on top of Anil's AM33XX DTS series
>  
> This series applies on top of the for_3.7/dts/ branch and Anil's
> "[v7,2/3] arm/dts: AM33XX: Configure pinmuxs for user leds control on Bone"
> patch that is part of the overall series adding led and pinctrl DTS data
> for AM33xx.
> 
> It is intended to correct the current labeling of gpios in the DTS before
> too many more drivers are submitted for AM33xx that have gpios not matching
> the docs.
> 
> Matt Porter (2):
>   ARM: dts: AM33XX: fix gpio node numbering to match hardware
>   ARM: dts: AM33XX: adjust leds to use the corrected gpio label
> 

I have tested this series on BeagleBone, also validated LED functionality.

Tested-Acked-By: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav

>  arch/arm/boot/dts/am335x-bone.dts |    8 ++++----
>  arch/arm/boot/dts/am33xx.dtsi     |    8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> -- 
> 1.7.9.5
> 
> 

