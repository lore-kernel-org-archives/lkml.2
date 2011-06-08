Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1FHMho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 08:37:44 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:8356
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab1FHMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:37:43 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz936eK1432N98dKzz1202hzz15d4R8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMH1QM-01-5B4-02
X-M-MSG: 
Date: Wed, 8 Jun 2011 14:37:58 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] dma-debug: print some unfreed allocations
Message-ID: <20110608123758.GB21591@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
 <20110516110029.GC31309@amd.com>
 <1305758908.8827.3.camel@jlt3.sipsolutions.net>
 <20110519081931.GM31309@amd.com>
 <1305909418.4640.13.camel@jlt3.sipsolutions.net>
 <20110523123508.GC27867@amd.com>
 <1307531016.3961.5.camel@jlt3.sipsolutions.net>
 <20110608121608.GA21591@amd.com>
 <1307536007.30277.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307536007.30277.0.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 08:26:47AM -0400, Johannes Berg wrote:
> On Wed, 2011-06-08 at 14:16 +0200, Roedel, Joerg wrote:
> 
> > > I see something similar was merged printing just the first one (and
> > > without stack trace it seems?). Are you still interested in this?
> > 
> > Sure, still interested. The code which prints out the first entry has
> > been around for some time, its nothing new afaik.
> 
> Ok. I was thinking of 
> commit ba4b87ad5497cba555954885db99c99627f93748
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Thu Mar 31 08:08:09 2011 -0400
> 
>     dma-debug: print information about leaked entry
> 
> which is fairly recent, recent enough that my original patch no longer
> applied anyway :-)

Ah, okay. I thought this change was older :-)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

