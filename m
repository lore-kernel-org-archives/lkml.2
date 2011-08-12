Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1HLWOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:14:17 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:39503 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312Ab1HLWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:14:14 -0400
Date: Fri, 12 Aug 2011 15:14:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>
Subject: Re: linux-next: Tree for Aug 12 (benet/be2net)
Message-Id: <20110812151409.b8af0108.rdunlap@xenotime.net>
In-Reply-To: <20110812150607.2303e10e@nehalam.ftrdhcpuser.net>
References: <20110812171311.4d7bb640f38838bf7c34df50@canb.auug.org.au>
	<20110812135618.a209d9af.rdunlap@xenotime.net>
	<20110812150607.2303e10e@nehalam.ftrdhcpuser.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 15:06:07 -0700 Stephen Hemminger wrote:

> On Fri, 12 Aug 2011 13:56:18 -0700
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > On Fri, 12 Aug 2011 17:13:11 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > [The kernel.org mirroring is being very slow today]
> > 
> >   [s.l.o.w.]
> >  
> > > The net tree gained a build failure do I used the version from
> > > next-20110811.
> > 
> > 
> > On i386:
> > 
> > drivers/built-in.o: In function `be_rx_eqd_update':
> > be_main.c:(.text+0x569229): undefined reference to `__udivdi3'
> > 
> 
> Already fixed:

That's really good news.  It appears to be re-b0rked
or this patch is not in linux-next yet.


> Author: Eric Dumazet <eric.dumazet@gmail.com>  2011-08-08 23:23:07
> Committer: David S. Miller <davem@davemloft.net>  2011-08-12 02:54:22
> Parent: 9aebddd11be42366f89b0296590770c02797aa98 (be2net: Move the Emulex driver)
> Branches: master, remotes/origin/master
> Follows: v3.0
> Precedes: 
> 
>     benet: fix build error on 32bit arch
>     
>     Error comes from commit ac124ff973e27802797
>     (be2net: cleanup and refactor stats code)
>     
>     ERROR: "__udivdi3" [drivers/net/benet/be2net.ko] undefined!
>     
>     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>     CC: Sathya Perla <sathya.perla@emulex.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
