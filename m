Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0GHPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:00:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33734 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749Ab0GHPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:00:36 -0400
Date: Thu, 8 Jul 2010 11:00:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ma, Ling" <ling.ma@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip] Revert x86, mem: Optimize memcpy by avoiding
	memory false dependece
Message-ID: <20100708150033.GA10224@Krystal>
References: <20100708062733.GA24740@Krystal> <20100708071153.GH4414@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708071153.GH4414@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:00:21 up 166 days, 17:37,  7 users,  load average: 0.04, 0.05,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > * Ma, Ling (ling.ma@intel.com) wrote:
> > > Hi Mathieu
> > > 
> > > I did git revert as bellow
> > >     Revert "x86, mem: Optimize memcpy by avoiding memory false dependece"
> > > 
> > >     This reverts commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087.
> > > And I found the machine will crash with your config file
> > > 
> > > Could you revert the patch : 77ff5e49c20bb72a99a12bfb00dbf90b2302f087 on your
> > > machine, and check it again ?
> > 
> > Hi Ling,
> > 
> > I just successfully booted my machine 3 times in a row with a revert of 
> > commit a1e5278e40f16a4611264f8da9e557c16cb6f6ed from -tip. This is actually 
> > the same as reverting commit 77ff5e49c20bb72a99a12bfb00dbf90b2302f087, as 
> > a1e5278e40f16a4611264f8da9e557c16cb6f6ed is simply a merge of that commit 
> > (the diffs are exactly the same).
> > 
> > Without this revert, the machine gets to:
> 
> Please check latest -tip (2a74852 or later), the commit should be gone now.

Will do, thanks!

Mathieu

> 
> There's clearly some (boundary-condition?) bug in the assembly code of 
> 77ff5e49c2.
> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
