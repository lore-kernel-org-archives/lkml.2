Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1K2KEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:04:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46387 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1K2KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:04:50 -0500
Date: Tue, 29 Nov 2011 10:04:42 +0000
From: Will Deacon <will.deacon@arm.com>
To: David Miller <davem@davemloft.net>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mmaruseac@ixiacom.com" <mmaruseac@ixiacom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer dereference in mainline and next
Message-ID: <20111129100442.GB26310@mudshark.cambridge.arm.com>
References: <20111128141846.GA2911@mudshark.cambridge.arm.com>
 <1322490804.2292.34.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111128143558.GC2911@mudshark.cambridge.arm.com>
 <20111128.170840.1847881572380941723.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111128.170840.1847881572380941723.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:08:40PM +0000, David Miller wrote:
> From: Will Deacon <will.deacon@arm.com>
> Date: Mon, 28 Nov 2011 14:35:58 +0000
> 
> > On Mon, Nov 28, 2011 at 02:33:24PM +0000, Eric Dumazet wrote:
> >> Le lundi 28 novembre 2011 à 14:18 +0000, Will Deacon a écrit :
> >> > Hello,
> >> > 
> >> > Commit f04565dd ("dev: use name hash for dev_seq_ops") requires a struct
> >> > dev_iter_state to be allocated for the seq_file->private member, as that is
> >> > used to implement the name hash.
> >> > 
> >> > Unfortunately, the dev_mcast code wasn't updated and so only allocates space
> >> > for a seq_net_private, leading to the following NULL dereference (removed
> >> > static inline annotations to get sane backtrace):
> > 
> > [...]
> > 
> >> Anton Blanchard already provided a fix for this problem.
> >> 
> >> http://patchwork.ozlabs.org/patch/127931/
> > 
> > Ok, great - as long as it gets fixed!
> 
> Please in the future report networking bugs to netdev@vger.kernel.org as that
> will reach the largest number of networking developers.

Sure, I just stumbled across this testing some ARM stuff, but I'll bear that
in mind in future.

Cheers,

Will
