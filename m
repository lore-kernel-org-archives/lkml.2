Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2GMVmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:42:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2GMVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:42:46 -0400
Date: Fri, 13 Jul 2012 14:42:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
Message-Id: <20120713144244.f3c9fb27.akpm@linux-foundation.org>
In-Reply-To: <1342103878.18274.98.camel@sauron.fi.intel.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	<1342103878.18274.98.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 17:37:58 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Tue, 2012-07-03 at 16:43 +0300, Artem Bityutskiy wrote:
> > This patch-set makes sysv file-system stop using the VFS '->write_supers()'
> > call-back and the '->s_dirt' superblock field because I plan to remove them
> > once all users are gone.
> 
> Hi Andrew,
> 
> would you please pick this patch-set as well? I also sent you an update
> for hfs and hfsplus file-systems today - found a bug while doing some
> more testing. Also, I sent UFS changes today, very similar. Most
> probably no one will reply and I hope you would pick them as well.
> 

The issue Alan raised around the superblock timestamp is still up in
the air.  I guess he's a slow typist ;)

My take is "no, we don't need to do that any more" - surely all Linux
systems have a functional hardware clock.  But the changelog should be
updated to describe and justify the decision.

