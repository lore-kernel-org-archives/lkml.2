Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0EaAsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:48:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40526 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0EaAsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:48:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 May 2010 09:43:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Paul Menage <menage@google.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
Message-Id: <20100531094357.2d26735a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTilNrrsNluDBUlXCsZMz7d_-VHn31Ogvkw9AUPnE@mail.gmail.com>
References: <1275059781-9831-1-git-send-email-gthelen@google.com>
	<AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com>
	<20100531084529.2b1f0d25.kamezawa.hiroyu@jp.fujitsu.com>
	<20100531085431.a45b30b9.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTilNrrsNluDBUlXCsZMz7d_-VHn31Ogvkw9AUPnE@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 May 2010 17:44:34 -0700
Greg Thelen <gthelen@google.com> wrote:

> On Sun, May 30, 2010 at 4:54 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 31 May 2010 08:45:29 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> >> On Fri, 28 May 2010 15:25:08 -0700
> >> Paul Menage <menage@google.com> wrote:
> >>
> >> > On Fri, May 28, 2010 at 8:16 AM, Greg Thelen <gthelen@google.com> wrote:
> >> > >
> >> > > Signed-off-by: Greg Thelen <gthelen@google.com>
> >> >
> >> > Acked-by: Paul Menage <menage@google.com>
> >> >
> >> > Good catch, thanks.
> >> >
> >> Nice Catch.
> >> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>
> >> But, who breaks this ? Do we need backport this against old kernels ?
> >>
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fae9c791703606636c1220e47f6690660042ce7f
> >
> > Hmm. this one. and 2.6.34 needs this patch. Greg, could you post this to
> > stable-2.6.34 tree ?
> 
> Given that I forgot to include "Cc: stable <stable@kernel.org>" in the
> patch, I assume the best way to get this patch into -stable is for me
> to email the commit id to stable@kernel.org once the patch is accepted
> into Linus' tree.  Let me know if there is a better way.
> 

Yes, it's best to CC stable@kernel.org. But please specify what version of
kernels requires this patch as "for 2.6.34"

Thank you,
-Kame

