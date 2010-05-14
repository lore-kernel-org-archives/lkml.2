Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0ENFov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:44:51 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53466 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0ENFot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:44:49 -0400
Date: Fri, 14 May 2010 11:14:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100514054441.GY3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
 <20100513203654.GA14528@tango.0pointer.de>
 <20100513204159.GA15291@tango.0pointer.de>
 <20100513210738.GV3296@balbir.in.ibm.com>
 <20100513235542.GA30093@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100513235542.GA30093@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lennart Poettering <mzxreary@0pointer.de> [2010-05-14 01:55:42]:

> On Fri, 14.05.10 02:37, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
> 
> > > > Oh, that is possible? How would I do that? 
> > > > 
> > > > This certainly doesn't work:
> > > > 
> > > > # mount waldo -t cgroup /tmp/xxxx -o defaults
> > > 
> > > An neither does this:
> > > 
> > > # mount waldo -t cgroup /tmp/xxxx -o name=systemd
> > > 
> > > (the mount() syscall fails with EINVAL here, the other one fails with EBUSY)
> > >
> > 
> > Can you try the command below
> > 
> > mount -t cgroup cgroup -o none,name=hello /cgroup/ 
> > 
> > Works for me.
> 
> That line certainly works, but unfortunately your own libcgroup
> completely ignores mount points like this. Meh.
>

Lets fix it, we never thought of using named hierarchies, but it
should not be too hard to fix. 

-- 
	Three Cheers,
	Balbir
