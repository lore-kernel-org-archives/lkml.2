Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab0ENIMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:12:13 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36808 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0ENIMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:12:07 -0400
Date: Fri, 14 May 2010 13:41:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100514081155.GD3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <1273785546.5605.3556.camel@twins>
 <20100514000252.GB30093@tango.0pointer.de>
 <1273819904.5605.3562.camel@twins>
 <1273821821.5605.3572.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273821821.5605.3572.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-14 09:23:41]:

> On Fri, 2010-05-14 at 08:51 +0200, Peter Zijlstra wrote:
> > Init using the bare minimum possible only seems like a sensible thing.
> > Once the basic stuff is running you can detect whats available and use
> > it if needed/wanted. 
> 
> I really think init should be able to run regardless of any CONFIG_*
> option. The only thing that should avoid init from running is not being
> able to mount the filesystem with init on it.
>

I suppose we'll continue to have alternative with the init=
commandline option. If you look at the boot process today, we do
already rely on features (CONFIG_*) for bootup. Changing the default
to have CONFIG_CGROUP=y (without any of the controllers) would work,
won't it? Is that too high an overhead/build or runtime wise? 

-- 
	Three Cheers,
	Balbir
