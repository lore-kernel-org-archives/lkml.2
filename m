Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1HVIQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:16:25 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9004 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1HVIQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:16:21 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH v2 07/11] Watchdog: DA9052 watchdog support
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312552311.5572.142.camel@L-0532.kpit.com>
References: <1312552311.5572.142.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 22 Aug 2011 13:43:43 +0530
Message-ID: <1314000823.1740.4.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 19:22 +0530, ashishj3 wrote: 
> This driver adds support for the watchdog functionality provided by the Dialog
> Semiconductor DA9052 PMIC chip.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since V2:
> - Code restructured for simplicty.
> - Add watchdog documentation.
> - Remove Auto strobing feature.
> - Remove strobe filtering flag.
> ---
If there are no comments then can this patch get ACK?


