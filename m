Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1GEK3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 06:29:52 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:11708
	"EHLO CH1EHSOBE017.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755377Ab1GEK3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 06:29:51 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
Subject: Re: [PATCH 9/11] Backlight: DA9052 Backlight driver v1
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: <rpurdie@rpsys.net>
CC: <tfransosi@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, <dchen@diasemi.com>
In-Reply-To: <1309270692.376.227.camel@L-0532.kpit.com>
References: <1309270692.376.227.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 5 Jul 2011 15:59:33 +0530
Message-ID: <1309861773.960.3.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no comments then can you please Ack this patch.

On Tue, 2011-06-28 at 19:48 +0530, ashishj3 wrote: 
> DA9052 PMIC has capability to supply power for upto 3 banks of 6 white serial
> LEDS. It can also control intensity of independent banks. To drive these
> banks boost converter will provide up to 24V and forward current of max. 50mA.
> 
> This patch controls intensity of the individual WLEDs bank through
> DA9052 PMIC.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---


