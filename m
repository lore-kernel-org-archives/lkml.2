Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030849Ab2CFO5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:57:01 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:6019
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893Ab2CFO5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:57:00 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzz8275dhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: Query about regmap SPI
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lrg <lrg@ti.com>
In-Reply-To: <1331045140.32512.7.camel@matrix>
References: <1331045140.32512.7.camel@matrix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 6 Mar 2012 20:38:52 +0530
Message-ID: <1331046532.32512.35.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 20:15 +0530, Ashish Chavan wrote:
> On Tue, Mar 06, 2012 at 12:53:51PM +0500, Ashish Chavan wrote:
> 

> Please always CC the relevant mailing lists on postings.  I shouldn't
> need to remind you about this stuff.

Yes, I agree :-(
It's my mistake that I missed linux-kernel@vger.kernel.org


> No, implementing stuff like this in individual device drivers rather
> defeats the point of having frameworks.  It sounds like it should be
> trivial to add support for this to regmap.

I also think that there should be a way to handle this kind of stuff by
the framework. May I know if you have any plan to add this to regmap? or
should I come up with a patch to extend regmap to support this and
propose you?


