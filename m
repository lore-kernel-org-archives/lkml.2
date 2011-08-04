Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1HDMsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:48:05 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:3136
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568Ab1HDMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:47:57 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz936eK1432N98dKzz1202h10d2nzz8275bhz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [Patch v2 04/11]Power: DA9052 battery driver
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linaro-dev@lists.linaro.org>, <cbou@mail.ru>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>
In-Reply-To: <1311339141.1796.42.camel@L-0532.kpit.com>
References: <1311339141.1796.42.camel@L-0532.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 4 Aug 2011 18:17:52 +0530
Message-ID: <1312462072.2388.1.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 18:22 +0530, ashishj3 wrote: 
> Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
> for definitions and methods.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since v2
> - Correct code styling for inline functions
> - Remove averaging algorithm
> - Set use_for_apm thru board specific parameter
> ---
Any comments on this patch?


