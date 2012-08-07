Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2HGT5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:45 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:49431
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932125Ab2HGT5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:40 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(z5109hz98dIc89bh1432Ic540Kzz1202hzz8275ch8275dhz2fh2a8h668h839hd25hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Arnd Bergmann <arnd@arndb.de>, Dongjin Kim <tobetter@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?ks_c_5601-1987?B?yLi9xTogW1BBVENIIDIvNF0gYXJtL2R0czogZXh5bm9zNDogQWRk?=
 =?ks_c_5601-1987?Q?_DTS_files_derived_from_common_Exynos4?=
Thread-Topic: [PATCH 2/4] arm/dts: exynos4: Add DTS files derived from
 common Exynos4
Thread-Index: AQHNdM/8uScTd8hIxUuwQF+02jXET5dOvs0AgAAEiVY=
Date: Tue, 7 Aug 2012 19:57:33 +0000
Message-ID: <A6A3B7488C419F488E5B13FFD03C08AD2F4372EB@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344366398-19022-1-git-send-email-dongjin.kim@agreeyamobility.net>,<201208071938.26507.arnd@arndb.de>
In-Reply-To: <201208071938.26507.arnd@arndb.de>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.177.223.193]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
X-OriginatorOrg: agreeyamobility.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q77JvpAq014979

Hi,

I didn't use -M and I couldn't see any difference with the it.
Did I make something wrong on that patch?

Thank you in advance.
Dongjin.
________________________________________
º¸³½ »ç¶÷: Arnd Bergmann [arnd@arndb.de]
º¸³½ ³¯Â¥: 2012³â 8¿ù 8ÀÏ ¼ö¿äÀÏ ¿ÀÀü 4:38
¹Ş´Â »ç¶÷: Dongjin Kim
ÂüÁ¶: Dongjin Kim; Russell King; Thomas Abraham; Kukjin Kim; Grant Likely; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
Á¦¸ñ: Re: [PATCH 2/4] arm/dts: exynos4: Add DTS files derived from common Exynos4

On Tuesday 07 August 2012, Dongjin Kim wrote:
>
> This patch creates a DTS file, exynos4.dtsi, for Exynos4210/4x12 and it
> describes common device nodes. SoC specific device nodes are described in
> another DTS file derived from this, exynos4210.dtsi and exynos4412.dtsi.
>
> exynos4412.dtsi is added new for Exynos4412 as well as exynos4210 is modified
> for Exynos4210 specific device nodes.
>
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  arch/arm/boot/dts/exynos4.dtsi    |  404 +++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos4210.dtsi |  374 +---------------------------------
>  arch/arm/boot/dts/exynos4412.dtsi |  104 ++++++++++
>  3 files changed, 510 insertions(+), 372 deletions(-)

Looks good in principle. I would hope that "git format-patch -M" can detect this
mostly-moved filed. Did you use that?

        Arnd

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
