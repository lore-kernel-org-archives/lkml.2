Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1FHMPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:15:53 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48118 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1FHMPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:15:52 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz936eK179dN168aJ1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMH0Q8-02-4QJ-02
X-M-MSG: 
Date: Wed, 8 Jun 2011 14:16:08 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] dma-debug: print some unfreed allocations
Message-ID: <20110608121608.GA21591@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
 <20110516110029.GC31309@amd.com>
 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
 <20110519081931.GM31309@amd.com>
 <1305909418.4640.13.camel@jlt3.sipsolutions.net>
 <20110523123508.GC27867@amd.com>
 <1307531016.3961.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307531016.3961.5.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:03:36AM -0400, Johannes Berg wrote:
> On Mon, 2011-05-23 at 14:35 +0200, Roedel, Joerg wrote:
> 
> > > +#ifdef CONFIG_STACKTRACE
> > > +	num_show_pending_dent = debugfs_create_u32("num_show_pending", 0644,
> > > +						   dma_debug_dent,
> > > +						   &num_show_pending);
> > > +	if (!num_show_pending_dent)
> > > +		goto out_err;
> > > +#endif
> > 
> > Hmm, thinking more about this, do we need to introduce a new variable at
> > all? It should fit well into the dma-api/all_errors and
> > dma-api/num_errors configurables. 
> 
> I see something similar was merged printing just the first one (and
> without stack trace it seems?). Are you still interested in this?

Sure, still interested. The code which prints out the first entry has
been around for some time, its nothing new afaik.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

