Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0EMVHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:07:47 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44298 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0EMVHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:07:45 -0400
Date: Fri, 14 May 2010 02:37:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100513210738.GV3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
 <20100513203654.GA14528@tango.0pointer.de>
 <20100513204159.GA15291@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100513204159.GA15291@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Poettering <mzxreary@0pointer.de> [2010-05-13 22:41:59]:

> On Thu, 13.05.10 22:36, Lennart Poettering (mzxreary@0pointer.de) wrote:
> 
> > On Thu, 13.05.10 13:06, Paul Menage (menage@google.com) wrote:
> > 
> > > 
> > > On Thu, May 13, 2010 at 7:03 AM, Lennart Poettering
> > > <mzxreary@0pointer.de> wrote:
> > > > By default systemd will create its groups in the "debug" hierarchy, (at
> > > > least for now, in the long run i'd like to see "noop" hierarchy or so,
> > > > that doesn't sound so temporary), since that controller is not useful
> > > 
> > > If you just want to track processes, mount a (named) hierarchy with no
> > > attached subsystems.
> > 
> > Oh, that is possible? How would I do that? 
> > 
> > This certainly doesn't work:
> > 
> > # mount waldo -t cgroup /tmp/xxxx -o defaults
> 
> An neither does this:
> 
> # mount waldo -t cgroup /tmp/xxxx -o name=systemd
> 
> (the mount() syscall fails with EINVAL here, the other one fails with EBUSY)
>

Can you try the command below

mount -t cgroup cgroup -o none,name=hello /cgroup/ 

Works for me.

-- 
	Three Cheers,
	Balbir
