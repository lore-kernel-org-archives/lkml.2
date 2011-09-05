Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1IEGOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 02:14:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57860 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1IEGOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 02:14:25 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [Patch v2 08/11] Touch: DA9052 touchscreen driver
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <dmitry.torokhov@gmail.com>
CC: <m.grzeschik@pengutronix.de>, <randy.dunlap@oracle.com>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>
In-Reply-To: <1314000728.1740.2.camel@L-0532.kpit.com>
References: <1313157026.5312.1.camel@L-0532.kpit.com>
	 <1314000728.1740.2.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 5 Sep 2011 11:43:55 +0530
Message-ID: <1315203235.4000.2.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.37]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 13:42 +0530, ashishj3 wrote:
> On Fri, 2011-08-12 at 19:20 +0530, ashishj3 wrote: 
> > This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
> > controller.
> > 
> > DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
> > functionalities.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> > Changes since v2:
> > - Replace kthreads with workqueue
> > - Remove kfifos
> > - Remove extra struct memebers
> > - Taken care for bus type
> > - Replace da9052_set/clear function with da9052_reg_update ( as DA9052 MFD got modified)
> > - Add open and close functionality
> > ---
> In case there are no comments then can this patch get ACK?
Any comments that you like to share?


