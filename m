Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2F0KJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:09:30 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:59123
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab2F0KJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:09:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 27 Jun 2012 18:10:25 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120627101025.GA10476@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AB6D43A9-FC54-40D2-A9B0-8B2E785124F9@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 09:03:42AM -0500, Kumar Gala wrote:
> 
> On Jun 26, 2012, at 5:25 AM, Zhao Chenhui wrote:
> 
> > Do hardware timebase sync. Firstly, stop all timebases, and transfer
> > the timebase value of the boot core to the other core. Finally,
> > start all timebases.
> > 
> > Only apply to dual-core chips, such as MPC8572, P2020, etc.
> > 
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> > Changes for v6:
> > * added 85xx_TB_SYNC
> > * added isync() after set_tb()
> > * removed extra entries from mpc85xx_smp_guts_ids
> 
> Why only on dual-core chips?  Is this because of something related to 2 cores, or related to corenet vs non-corenet SoCs and how turning on/off the timebase works in the SOC?
> 
> - k

I am working on a timebase sync patch for corenet SoCs which have more than 2 cores.
It is based on this patch.

-Chenhui

