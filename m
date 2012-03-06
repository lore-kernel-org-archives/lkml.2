Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2CFRWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:22:18 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:6672
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031Ab2CFRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:22:17 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: Query about regmap SPI
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, lrg <lrg@ti.com>
In-Reply-To: <20120306163012.GW19635@opensource.wolfsonmicro.com>
References: <1331045140.32512.7.camel@matrix>
	 <1331046532.32512.35.camel@matrix>
	 <20120306163012.GW19635@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 6 Mar 2012 23:04:12 +0530
Message-ID: <1331055252.2453.8.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 16:30 +0000, Mark Brown wrote:
> On Tue, Mar 06, 2012 at 08:38:52PM +0530, Ashish Chavan wrote:
> 
> > I also think that there should be a way to handle this kind of stuff by
> > the framework. May I know if you have any plan to add this to regmap? or
> > should I come up with a patch to extend regmap to support this and
> > propose you?
> 
> I have no need for it so I'm unlikely to work on it myself, if you were
> to send a patch that'd be great.

OK, I will go through regmap sources in detail to find out appropriate
place to put this. BTW do you have any recommendation in terms of a good
way to achieve this. e.g. will it be useful and generic enough if we
introduce two more fields like read/write_flag_mask to indicate shifting
and use those fields before applying read/write_flag_masks?


