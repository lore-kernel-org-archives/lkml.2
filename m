Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab2C3IJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:09:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65025 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab2C3IJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:09:22 -0400
Message-ID: <4F756A2D.9020500@linaro.org>
Date: Fri, 30 Mar 2012 16:09:17 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>
Subject: Re: [PATCH] ARM: dts: imx6q: add anatop regulators
References: <1332214139-6833-1-git-send-email-paul.liu@linaro.org> <20120322074520.GD2213@S2101-09.ap.freescale.net>
In-Reply-To: <20120322074520.GD2213@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年03月22日 15:45), Shawn Guo wrote:
>> +				};
>> +
>> +				regulator-1p1@110 {
>> +					compatible = "fsl,anatop-regulator";
>> +					regulator-name = "vdd1p1";
>> +					regulator-min-microvolt = <800000>;
>> +					regulator-max-microvolt = <1400000>;
>> +					regulator-always-on;
>> +					reg = <0x110>;
>> +					anatop-vol-bit-shift = <8>;
>> +					anatop-vol-bit-width = <5>;
>> +					anatop-min-bit-val = <4>;
>> +					anatop-min-voltage = <800000>;
>> +					anatop-max-voltage = <1400000>;
> 
> 1.375V

Hi Shawn,

Sorry, why it is not 1.4V?

LDO 1p1 should be from range 0.8V to 1.4V on section 53.3.1
