Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0ENINE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:13:04 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39518 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0ENIM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:12:59 -0400
Date: Fri, 14 May 2010 13:42:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100514081248.GE3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <1273785546.5605.3556.camel@twins>
 <20100514000252.GB30093@tango.0pointer.de>
 <20100514054336.GX3296@balbir.in.ibm.com>
 <1273820028.5605.3565.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273820028.5605.3565.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-14 08:53:48]:

> On Fri, 2010-05-14 at 11:13 +0530, Balbir Singh wrote:
> 
> > I think the config options are the domains of the distributors 
> 
> Whoever runs a distro kernel anyway? This is LKML, we're kernel devs.
>

Heh! agreed, but we are a small population and moreover a large
population would benefit from systemd and parallel boot.
 
> > I am not sure why CONFIG_CGROUP=y is so bad, Peter, could you
> > elaborate? 
> 
> Because it adds code I don't use and adds to the compile overhead.

Not anymore, if systemd becomes the default :-)


-- 
	Three Cheers,
	Balbir
