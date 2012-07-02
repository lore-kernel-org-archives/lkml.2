Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2GBKnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:43:31 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14746
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932931Ab2GBKna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:43:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Mon, 2 Jul 2012 18:44:41 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120702104441.GB22108@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <1340748634.3732.27.camel@pasglop>
 <20120627102138.GB10476@localhost.localdomain>
 <1340797732.3732.46.camel@pasglop>
 <20120628033815.GA11387@localhost.localdomain>
 <1340880651.20977.83.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340880651.20977.83.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 08:50:51PM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2012-06-28 at 11:38 +0800, Zhao Chenhui wrote:
> > 
> > 
> > The bootloader have done a timebase sync. If we do not need KEXEC or
> > HOTPLUG_CPU feature, it is unnecessary to do it again at boot time of
> > kernel. I only compile the timebase sync routines
> > when users enable KEXEC or HOTPLUG_CPU. 
> 
> Still, how much are you really saving ? Is it worth the added mess and
> loss of test coverage ?
> 
> We have too many conditional stuff like that already.
> 
> Cheers,
> Ben.

OK. I will remove this config option.

-Chenhui

