Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2IHRly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 13:41:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49091 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2IHRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 13:41:53 -0400
Date: Sat, 8 Sep 2012 10:41:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.6-fixes 3/3] workqueue: fix possible idle
 worker depletion during CPU_ONLINE
Message-ID: <20120908174150.GE10788@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120907192939.GF9426@google.com>
 <20120907202249.GH9426@google.com>
 <20120907203414.GI9426@google.com>
 <20120907230556.GJ9426@google.com>
 <20120907230746.GK9426@google.com>
 <20120907234158.GL9426@google.com>
 <CACvQF51CEjqx_5pftzf6BwxCtyV8zGsVNBKjKBtt-L_iSxr4iQ@mail.gmail.com>
 <20120908172950.GA10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120908173234.GB10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF50CzHq3xAEwKOqgk=aO3nqn_A-60QEux7Ard9wAG3Akpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF50CzHq3xAEwKOqgk=aO3nqn_A-60QEux7Ard9wAG3Akpg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 01:40:19AM +0800, Lai Jiangshan wrote:
> On Sun, Sep 9, 2012 at 1:32 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Sat, Sep 08, 2012 at 10:29:50AM -0700, Tejun Heo wrote:
> >> > hotplug code can't iterate manager.  not rebind_work() nor UNBOUND for manager.
> >>
> >> Ah, right.  It isn't either on idle or busy list.  Maybe have
> >> pool->manager pointer?
> >
> > Ooh, this is what you did with the new patchset, right?
> 
> I already did it in V5 patchset. not in new patchset. I just change it
> as you like in V6.
> I change the strategy of calling may_rebind_manager().

Yeah, you did that and a lot else too.  Let's please isolate the fixes
and think about restructuring later.

Thanks.

-- 
tejun
