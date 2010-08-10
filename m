Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0HJMoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:44:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab0HJMod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:44:33 -0400
Date: Tue, 10 Aug 2010 14:44:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kawime@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: tomoyo-init (tomoyo-tools) results in kernel panic on kernel
 2.6.35-git2/3
In-Reply-To: <201008070504.o7754Daw083381@www262.sakura.ne.jp>
Message-ID: <alpine.LRH.2.00.1008101443340.2372@twin.jikos.cz>
References: <op.vg0yh9gtgp7xae@127.0.0.1> <201008070504.o7754Daw083381@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010, Tetsuo Handa wrote:

> > Hi, i just compiled the 2.6.35-git3 kernel on my computer using debian 64 bit
> > as i did with all other kernels before.
> > Booting the git2/3 kernel results in a kernel panic because of
> > /sbin/tomoyo-init.
> > 
> > No problem with the 2.6.35 kernel.
> > 
> > I've to remane /sbin/tomoyo-init to boot the kernel.
> > Now i purged tomoyo-tools version 2.2.0-20100225 (aptitude purge tomoyo-tool) and everything works ok.
> > Sorry, i forgot to backup the tomoyo-init script.
> > 
> > $ uname -a
> > Linux xxxxxx 2.6.35-git3 #4 SMP Fri Aug 6 15:22:08 CEST 2010 x86_64 GNU/Linux
> 
> Thank you for using TOMOYO. TOMOYO has changed a lot in 2.6.36. Therefore,
> you need to upgrade tomoyo-tools package. I'm testing it now.
> You can upgrade it by doing
> 
> # wget -O tomoyo-tools.tar.gz 'http://sourceforge.jp/projects/tomoyo/svn/view/trunk/2.3.x/tomoyo-tools.tar.gz?root=tomoyo&view=tar'
> # tar -zxf tomoyo-tools.tar.gz
> # make -C tomoyo-tools/ install
> 
> Then, please delete (or rename) /etc/tomoyo/ directory and run
> /usr/lib/tomoyo/init_policy .
> 
> Please see http://tomoyo.sourceforge.jp/2.3/ for more information.

Still, if a legacy userspace application is able to cause kernel panic, 
that sounds like something we'd rather fix immediately.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

