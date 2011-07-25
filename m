Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab1GYLoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:44:30 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58741
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750781Ab1GYLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:44:26 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [Patch v1 08/11] Touch: DA9052 touchscreen driver
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <randy.dunlap@oracle.com>, <dmitry.torokhov@gmail.com>
CC: <dmitry.torokhov@gmail.com>, <dtor@mail.ru>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>
In-Reply-To: <1310633890.284.90.camel@L-0532.kpit.com>
References: <1310633890.284.90.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 25 Jul 2011 17:13:11 +0530
Message-ID: <1311594191.4452.5.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.71.90]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 14:28 +0530, ashishj3 wrote: 
> This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
> controller.
> 
> DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
> functionalities.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
If there are no comments then can this patch get ACK?


