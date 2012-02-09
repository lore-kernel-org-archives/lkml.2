Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2BIPhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:37:40 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34287 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2BIPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:37:39 -0500
Date: Thu, 9 Feb 2012 16:37:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120209153730.GC22552@somewhere.redhat.com>
References: <20120201184045.GG2382@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202011404500.2074@router.home>
 <20120201201336.GI2382@linux.vnet.ibm.com>
 <4F2A58A1.90800@redhat.com>
 <20120202153437.GD2518@linux.vnet.ibm.com>
 <4F2AB66C.2030309@redhat.com>
 <20120202170134.GM2518@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202021124520.6338@router.home>
 <CAOtvUMdCZpQuSvutKHpMxthktTm_VkA1R99yxpNhxpsYN9wTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1202061218420.2799@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202061218420.2799@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 12:19:44PM -0600, Christoph Lameter wrote:
> On Sun, 5 Feb 2012, Gilad Ben-Yossef wrote
> 
> >
> > Frederic has the latest version in a git tree here:
> >
> > git://github.com/fweisbec/linux-dynticks.git
> >        nohz/cpuset-v2-pre-20120117
> >
> > It's on top latest rcu/core.
> 
> Hmmm.. A pull vs upstream leads to lots of conflicts.

Yeah it's based on the latest rcu/core branch that was pulled
on last -rc1. Better git checkout it than pull.

 
> 
> > But the good news is that with these hacks applied I managed to run a 100%
> > CPU task  with  zero interrupts  (ticks or  otherwise) on an isolated cpu.
> 
> Cool.
> 
> > Disregarding TLB overhead, you get bare metal performance with Linux user
> > space manageability and  debug capabilities.  Pretty magical really: It's like
> > eating your cake and having it too :-)
> 
> We definitely need that.
> 
