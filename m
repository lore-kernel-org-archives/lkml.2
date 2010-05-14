Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0ENGwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:52:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab0ENGwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:52:07 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, James Kosin <jkosin@intcomgrp.com>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
In-Reply-To: <20100514000252.GB30093@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop> <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <1273785546.5605.3556.camel@twins>
	 <20100514000252.GB30093@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 08:51:44 +0200
Message-ID: <1273819904.5605.3562.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 02:02 +0200, Lennart Poettering wrote:
> > Will it still work with a CONFIG_CGROUP=n kernel? I see distributions
> > deteriorate, you cannot even boot a raw bzImage kernel without initrd on
> > most distros (sure, its not too hard to fix, but still).
> 
> No it won't work without cgroups. 

I guess we'll finally have an answer for people on #kernelnewbies on
what distro is best suited for kernel development :-)


> > Requiring CONFIG_CGROUP=y to even get init running seems like a final
> > straw to ensure nobody will ever get anything to boot these days.
> 
> Well, I wasn't aware that cgroups is now in the kernel for the purpose
> that people should *not* use it.

Init using the bare minimum possible only seems like a sensible thing.
Once the basic stuff is running you can detect whats available and use
it if needed/wanted.

I very often build a CONFIG_CGROUP=n kernel, I simply strip down
my .config to the bare minimum because that builds fastest.


