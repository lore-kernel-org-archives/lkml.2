Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2C3IOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:14:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51576 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab2C3IOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:14:44 -0400
Date: Fri, 30 Mar 2012 16:14:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: Re: [PATCH] ARM: dts: imx6q: add anatop regulators
Message-ID: <20120330081444.GE3254@S2101-09.ap.freescale.net>
References: <1332214139-6833-1-git-send-email-paul.liu@linaro.org>
 <20120322074520.GD2213@S2101-09.ap.freescale.net>
 <4F756A2D.9020500@linaro.org>
MIME-Version: 1.0
In-Reply-To: <4F756A2D.9020500@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 04:09:17PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> (2012年03月22日 15:45), Shawn Guo wrote:
> >> +				};
> >> +
> >> +				regulator-1p1@110 {
> >> +					compatible = "fsl,anatop-regulator";
> >> +					regulator-name = "vdd1p1";
> >> +					regulator-min-microvolt = <800000>;
> >> +					regulator-max-microvolt = <1400000>;
> >> +					regulator-always-on;
> >> +					reg = <0x110>;
> >> +					anatop-vol-bit-shift = <8>;
> >> +					anatop-vol-bit-width = <5>;
> >> +					anatop-min-bit-val = <4>;
> >> +					anatop-min-voltage = <800000>;
> >> +					anatop-max-voltage = <1400000>;
> > 
> > 1.375V
> 
> Hi Shawn,
> 
> Sorry, why it is not 1.4V?
> 
> LDO 1p1 should be from range 0.8V to 1.4V on section 53.3.1

Hmm, I do not see 1.4V in register description (PMU_REG_1P1).

-- 
Regards,
Shawn
