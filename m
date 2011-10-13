Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1JMJCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:02:01 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:7338
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab1JMJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:02:00 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz936eK154dM1432N98dKzz1202hzzz32i2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: Re: [alsa-devel] [PATCH 6/9] ASoC: da7210: bugfix for head phone
 volume control
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20111012150101.GS3647@opensource.wolfsonmicro.com>
References: <1318431934.12107.421.camel@matrix>
	 <20111012150101.GS3647@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 14:42:33 +0530
Message-ID: <1318497153.12107.439.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-12 at 16:01 +0100, Mark Brown wrote:
> On Wed, Oct 12, 2011 at 08:35:34PM +0530, Ashish Chavan wrote:
> > This patch takes care of reserved bits of headphone volume
> > register by using correct volume range.
> 
> This doesn't apply, which is pretty surprising given that there's no
> obvious overlap at all with the rest of the code.

I guess this is mostly due to indirect dependence on [PATCH 1/9].
It applies after applying first patch.

> 
> > Tested on Samsung SMDK6410 board with DA7210 evaluation board.
> 
> This really isn't useful information in a changelog, apart from anything
> else this isn't going to be a system that it's easy for other people to
> reproduce.
> 
OK, will remove redundant info.


