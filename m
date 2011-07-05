Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1GEKdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:33:37 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:22257
	"EHLO CH1EHSOBE014.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753344Ab1GEKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:33:36 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v2
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linaro-dev@lists.linaro.org>, <lrg@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>
In-Reply-To: <1309353363.4448.10.camel@L-0532.kpit.com>
References: <1309353363.4448.10.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 5 Jul 2011 16:01:31 +0530
Message-ID: <1309861891.960.5.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no comments then can you please Ack this patch.

On Wed, 2011-06-29 at 18:46 +0530, ashishj3 wrote: 
> The DA9052 PMIC has below featured regulators:-
> 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
> 10 Programmable LDO's High PSSR, 1% accuracy.
> 
> This patch support all the DA9052 regulators. The output voltages are fully
> programmable via I2C or SPI interface. The platform data with regulation
> constraints is passed down from the board to the regulator.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Changes since v2
> - Check for current min_uA < 700000
> - Corrected current conversions from mA to uA
> ---


