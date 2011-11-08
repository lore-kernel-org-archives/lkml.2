Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1KHI2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:28:31 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22008 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753499Ab1KHI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:28:30 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bh8275dhz32i2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [Patch 5/11] Regulator: DA9052/53 regulator support v5
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linaro-dev@lists.linaro.org>, <lrg@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <paul.liu@linaro.org>
In-Reply-To: <1318950455.4644.65.camel@L-0761.kpit.com>
References: <1318950455.4644.65.camel@L-0761.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 8 Nov 2011 13:58:25 +0530
Message-ID: <1320740905.5640.3.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 20:37 +0530, ashishj3 wrote: 
> The Dialog PMIC has below featured regulators:-
> DA9052-BC - 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
> DA9053-AA/BX - 4 DVS Buck converters 0.5V - 2.5V upto 3Amp.
> DA9052/53 - 10 Programmable LDO's High PSSR, 1% accuracy.
> 
> This patch support all the DA9052 and Da9053 regulators. The output voltages are
> fully programmable via I2C or SPI interface. The platform data with regulation
> constraints is passed down from the board to the regulator.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> Tested-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> 
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
If there are no review commnets then can it get ACK?


