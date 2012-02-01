Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2BAIBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:01:20 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:17388
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755878Ab2BAIBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:01:19 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dhc1bhc31hc1ah2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: mfd regmap irq to handle some cases
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3C3@KCHJEXMB02.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA3C3@KCHJEXMB02.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 1 Feb 2012 13:25:14 +0530
Message-ID: <1328082914.19234.3.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 13:10 +0530, Ashish Jangam wrote:
> 
> > spurious interrupt we get on clearing event and event can be from any
> > mfd children. But since now, deferring event clear is not the approach
> > we can ignore about the spurious interrupt.
> > Now looking at the old issue of determining the RTC type (periodic or tick)
> > on event clearing this info (RTC type) gets lost for the register since in regmap_irq
> > we first clear and then process the event.
> 
> That we can handle easily enough by adding a flag to the interrupt
> definition deferring the acknowledgement.
> 
Can you let me know in which linux-next version this will be available so
that I can test it against the DA9052/53 RTC?


