Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2JRWIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:08:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2JRWIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:08:11 -0400
Date: Fri, 19 Oct 2012 00:08:09 +0200
From: Jan Kara <jack@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jan Kara <jack@suse.cz>, Fabio Coatti <fabio.coatti@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: ext3 issue on 3.6.1
Message-ID: <20121018220809.GD17646@quack.suse.cz>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
 <20121018212357.GA17646@quack.suse.cz>
 <1350596425.1366.15.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350596425.1366.15.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-10-12 23:40:25, Paul Bolle wrote:
> On Thu, 2012-10-18 at 23:23 +0200, Jan Kara wrote:
> > On Fri 12-10-12 14:57:55, Fabio Coatti wrote:
> > > [13031.051521] ------------[ cut here ]------------
> > > [13031.051576] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
> > > [13031.051624] Hardware name: ProLiant BL465c G7
> > > [13031.051668] Pid: 3344, comm: php Tainted: G        W
> > > 3.6.1-1000hz-preempt #2
> > > [13031.051746] Call Trace:
> > > [13031.051787]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
> > > [13031.051837]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
> > > [13031.051885]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
> > > [13031.051934]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
> > > [13031.051980]  [<ffffffff810eb001>] ? dput+0x147/0x154
> > > [13031.052027]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
> > > [13031.052073]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
> > > [13031.052123]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
> > > [13031.052169] ---[ end trace e60232a455c8e2dd ]---
> >   And this seems unrelated - likely an NFS problem... Let's sort this out
> > if you still see it after ext3 issue is solved.
> 
> Looks rather similar too https://lkml.org/lkml/2012/8/29/165 , doesn't
> it?
  Yup. I wonder why that patch didn't get merged. Neil?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
