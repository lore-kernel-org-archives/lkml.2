Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2JRVk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:40:28 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1045 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab2JRVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:40:27 -0400
Message-ID: <1350596425.1366.15.camel@x61.thuisdomein>
Subject: Re: ext3 issue on 3.6.1
From: Paul Bolle <pebolle@tiscali.nl>
To: Jan Kara <jack@suse.cz>
Cc: Fabio Coatti <fabio.coatti@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 23:40:25 +0200
In-Reply-To: <20121018212357.GA17646@quack.suse.cz>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
	 <20121018212357.GA17646@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2012 21:40:25.0766 (UTC) FILETIME=[2F2BCC60:01CDAD79]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 23:23 +0200, Jan Kara wrote:
> On Fri 12-10-12 14:57:55, Fabio Coatti wrote:
> > [13031.051521] ------------[ cut here ]------------
> > [13031.051576] WARNING: at fs/inode.c:280 drop_nlink+0x1b/0x35()
> > [13031.051624] Hardware name: ProLiant BL465c G7
> > [13031.051668] Pid: 3344, comm: php Tainted: G        W
> > 3.6.1-1000hz-preempt #2
> > [13031.051746] Call Trace:
> > [13031.051787]  [<ffffffff810578c4>] ? warn_slowpath_common+0x73/0x87
> > [13031.051837]  [<ffffffff810ec628>] ? drop_nlink+0x1b/0x35
> > [13031.051885]  [<ffffffff8118ad51>] ? nfs_dentry_iput+0x33/0x49
> > [13031.051934]  [<ffffffff810ea920>] ? d_kill+0xe8/0x108
> > [13031.051980]  [<ffffffff810eb001>] ? dput+0x147/0x154
> > [13031.052027]  [<ffffffff810d9e46>] ? __fput+0x19a/0x1b2
> > [13031.052073]  [<ffffffff8106bdf0>] ? task_work_run+0x4c/0x60
> > [13031.052123]  [<ffffffff815ff5e8>] ? int_signal+0x12/0x17
> > [13031.052169] ---[ end trace e60232a455c8e2dd ]---
>   And this seems unrelated - likely an NFS problem... Let's sort this out
> if you still see it after ext3 issue is solved.

Looks rather similar too https://lkml.org/lkml/2012/8/29/165 , doesn't
it?


Paul Bolle

