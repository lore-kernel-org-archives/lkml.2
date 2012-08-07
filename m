Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2HGTuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:50:18 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:38656
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2HGTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:50:17 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(z5109hz98dIc89bhc540Kzz1202hzzz2fh2a8h668h839hd25hf0ah107ah)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
Subject: =?ks_c_5601-1987?B?yLi9xTogW1BBVENIIDEvNF0gYXJtL2R0czogbWF4Nzc2ODY6IEFk?=
 =?ks_c_5601-1987?Q?d_DTS_file_for_max77686_PMIC?=
Thread-Topic: [PATCH 1/4] arm/dts: max77686: Add DTS file for max77686 PMIC
Thread-Index: AQHNdM+5kxHz8pLAJkOexm33/jWUi5dOvaEAgAACLOg=
Date: Tue, 7 Aug 2012 19:50:11 +0000
Message-ID: <A6A3B7488C419F488E5B13FFD03C08AD2F4372BC@SN2PRD0510MB370.namprd05.prod.outlook.com>
References: <1344366267-18971-1-git-send-email-dongjin.kim@agreeyamobility.net>,<20120807193413.GE14711@sirena.org.uk>
In-Reply-To: <20120807193413.GE14711@sirena.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q77JoOvJ014859

Hello,

Are you meaning VDD_MIF_1.0V, for example, would be replaced with another common name for other boards and my board file, exynos4412-odroidx.dts, describe the name again if necessary? Like below?

max77686.dtsi:
    buck1 {
         regulator-compatible = "BUCK1";
         regulator-name = "VDD_BUCK1_1.0V";
         regulator-min-microvolt = <800000>;
         regulator-max-microvolt = <1050000>;
         regulator-always-on;
         regulator-boot-on;
    };

my board's DTS file:
    buck1 {
        regulator-name = "VDD_MIF_1.0V";
    }

Thank you in advance.
Dongjin.
________________________________________
º¸³½ »ç¶÷: Mark Brown [broonie@opensource.wolfsonmicro.com]
º¸³½ ³¯Â¥: 2012³â 8¿ù 8ÀÏ ¼ö¿äÀÏ ¿ÀÀü 4:34
¹Ş´Â »ç¶÷: Dongjin Kim
ÂüÁ¶: Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Dongjin Kim
Á¦¸ñ: Re: [PATCH 1/4] arm/dts: max77686: Add DTS file for max77686 PMIC

On Wed, Aug 08, 2012 at 04:04:11AM +0900, Dongjin Kim wrote:

> +                     buck1 {
> +                             regulator-compatible = "BUCK1";
> +                             regulator-name = "VDD_MIF_1.0V";
> +                             regulator-min-microvolt = <800000>;
> +                             regulator-max-microvolt = <1050000>;
> +                             regulator-always-on;
> +                             regulator-boot-on;
> +                     };

These settings for the regulators are clearly specific to the board
rather than the device so should be in the board file.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
