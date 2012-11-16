Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2KPKrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:47:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11881 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2KPKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:47:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 16 Nov 2012 02:47:16 -0800
Message-ID: <50A619B3.9000607@nvidia.com>
Date: Fri, 16 Nov 2012 05:47:15 -0500
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH V4 1/2] mfd: add TI TPS80031 mfd core driver
References: <1352907569-12466-1-git-send-email-ldewangan@nvidia.com> <20121115075052.GJ7599@opensource.wolfsonmicro.com>
In-Reply-To: <20121115075052.GJ7599@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 02:50 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Nov 14, 2012 at 09:09:28PM +0530, Laxman Dewangan wrote:
>> TPS80031/ TPS80032 Fully Integrated Power Management with Power
>> Path and Battery Charger. The device provides five configurable
>> step-down converters, 11 general purpose LDOs, USB OTG Module,
>> ADC, RTC, 2 PWM, System Voltage Regulator/Battery Charger with
>> Power Path from USB, 32K clock generator.
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This patch use the function regmap_irq_get_domain() which is not in mfd 
subsystem. So either it need to go to regmap branch or Samuel need to 
pull this change.
It is good that it will apply on the same way as discussed in patch
[PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework for interrupt



