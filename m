Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1GNH7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:59:07 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:54336
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab1GNH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:59:05 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 07/11] Watchdog: DA9052 watchdog support v1
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <linaro-dev@lists.linaro.org>
In-Reply-To: <1309872103.960.79.camel@L-0532.kpit.com>
References: <1309872103.960.79.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="cp1252"
Date: Thu, 14 Jul 2011 13:27:12 +0530
Message-ID: <1310630232.284.16.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.42]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 18:51 +0530, ashishj3 wrote: 
> This driver adds support for the watchdog functionality provided by the Dialog
> Semiconductor DA9052 PMIC chip.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
If there are no comments then can you ACK this patch?


