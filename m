Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2F1Dhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 23:37:46 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:56430
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758116Ab2F1DhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 23:37:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 28 Jun 2012 11:38:15 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120628033815.GA11387@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <1340748634.3732.27.camel@pasglop>
 <20120627102138.GB10476@localhost.localdomain>
 <1340797732.3732.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340797732.3732.46.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:48:52PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2012-06-27 at 18:21 +0800, Zhao Chenhui wrote:
> > > What's that CONFIG option for ?
> > > 
> > > Cheers,
> > > Ben.
> > 
> > This option is to guard the timebase sync routines. It is selected
> > when KEXEC or HOTPLUG_CPU is enabled on Freescale Book-E platforms.
> 
> Any reason not to just make it unconditional ? That sort of config
> option tend to just confuse things and make bug reports harder to sort
> out.... Also you decrease your test coverage.
> 
> Cheers,
> Ben.

The bootloader have done a timebase sync. If we do not need KEXEC or HOTPLUG_CPU feature,
it is unnecessary to do it again at boot time of kernel. I only compile the timebase sync routines
when users enable KEXEC or HOTPLUG_CPU.

-Chenhui

