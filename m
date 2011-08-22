Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1HVIPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:15:47 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26052 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1HVIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:15:41 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [Patch v2 08/11] Touch: DA9052 touchscreen driver
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <dmitry.torokhov@gmail.com>
CC: <m.grzeschik@pengutronix.de>, <randy.dunlap@oracle.com>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1313157026.5312.1.camel@L-0532.kpit.com>
References: <1313157026.5312.1.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 22 Aug 2011 13:42:08 +0530
Message-ID: <1314000728.1740.2.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 19:20 +0530, ashishj3 wrote: 
> This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
> controller.
> 
> DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
> functionalities.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since v2:
> - Replace kthreads with workqueue
> - Remove kfifos
> - Remove extra struct memebers
> - Taken care for bus type
> - Replace da9052_set/clear function with da9052_reg_update ( as DA9052 MFD got modified)
> - Add open and close functionality
> ---
In case there are no comments then can this patch get ACK?


