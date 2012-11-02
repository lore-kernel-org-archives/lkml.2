Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab2KBIyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:54:04 -0400
Received: from [216.32.181.185] ([216.32.181.185]:33235 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab2KBIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:54:00 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1de0h1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: Re: [patch v1 1/2] mfd: i2c issue fix for DA9052/53 and support
 for DA9053-BC
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
In-Reply-To: <20121101143130.GI4413@opensource.wolfsonmicro.com>
References: <1351750722.19193.16.camel@dhruva>
	 <20121101143130.GI4413@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 2 Nov 2012 14:22:06 +0530
Message-ID: <1351846326.25938.2.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 14:31 +0000, Mark Brown wrote:
> On Thu, Nov 01, 2012 at 11:48:42AM +0530, Ashish Jangam wrote:
> 
> > This patch fixes this issue to by following any read or write with a dummy read
> > to a safe register address. A safe register address is one where the contents
> > will not affect the operation of the system.
> 
> > Apart from this the patch also adds support to the DA9053-BC PMIC chip
> 
> This is two separate changes and so should be two separate patches (one
> is a bugfix and one isn't...).
I merged these two changes since I2C fix has got some dependency on
DA9053-BC PMIC. But I can separate out the things, its better.


