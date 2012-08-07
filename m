Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2HGTeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:34:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47574 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2HGTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:34:16 -0400
Date: Tue, 7 Aug 2012 20:34:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dongjin Kim <dongjin.kim@agreeyamobility.net>
Subject: Re: [PATCH 1/4] arm/dts: max77686: Add DTS file for max77686 PMIC
Message-ID: <20120807193413.GE14711@sirena.org.uk>
References: <1344366267-18971-1-git-send-email-dongjin.kim@agreeyamobility.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344366267-18971-1-git-send-email-dongjin.kim@agreeyamobility.net>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:04:11AM +0900, Dongjin Kim wrote:

> +			buck1 {
> +				regulator-compatible = "BUCK1";
> +				regulator-name = "VDD_MIF_1.0V";
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <1050000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +			};

These settings for the regulators are clearly specific to the board
rather than the device so should be in the board file.
