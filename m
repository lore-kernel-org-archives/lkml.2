Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab2HHNaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:30:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56807 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758211Ab2HHNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:30:15 -0400
Date: Wed, 8 Aug 2012 14:30:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: =?utf-8?B?yLjvv73vv706IFtQQVRD?= =?utf-8?Q?H?= 1/4] arm/dts:
 max77686: Add DTS file for max77686 PMIC
Message-ID: <20120808133013.GY16861@opensource.wolfsonmicro.com>
References: <1344366267-18971-1-git-send-email-dongjin.kim@agreeyamobility.net>
 <20120807193413.GE14711@sirena.org.uk>
 <A6A3B7488C419F488E5B13FFD03C08AD2F4372BC@SN2PRD0510MB370.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6A3B7488C419F488E5B13FFD03C08AD2F4372BC@SN2PRD0510MB370.namprd05.prod.outlook.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 07:50:11PM +0000, Dongjin Kim wrote:

Please fix your mailer to word wrap within paragraphs.

> Are you meaning VDD_MIF_1.0V, for example, would be replaced with
> another common name for other boards and my board file,
> exynos4412-odroidx.dts, describe the name again if necessary? Like
> below?

No, the entire configuration.

> max77686.dtsi:
>     buck1 {
>          regulator-compatible = "BUCK1";
>          regulator-name = "VDD_BUCK1_1.0V";
>          regulator-min-microvolt = <800000>;
>          regulator-max-microvolt = <1050000>;
>          regulator-always-on;
>          regulator-boot-on;
>     };

Especially things like the voltage range might not be appropriate if the
regulator is used for a different purpose on a different board.
