Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2BRG6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:58:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36448 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2BRG6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:58:51 -0500
Date: Sat, 18 Feb 2012 10:58:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Feb 17 (kernel/kcmp.c)
Message-ID: <20120218065846.GA1905@moon>
References: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
 <4F3E95B7.3010700@xenotime.net>
 <20120218101446.64a7ea590b66f337762bfb57@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218101446.64a7ea590b66f337762bfb57@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 10:14:46AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 17 Feb 2012 10:00:23 -0800 Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > on i386:
> > 
> > kernel/kcmp.c:153:10: error: 'EOPNOTSUP' undeclared (first use in this 
> > function)
> 
> Caused by commit 0e8a8193207d ("syscalls, x86: add __NR_kcmp syscall")
> from the akpm tree.  Missing include of linux/errno.h ...
> 

Ouch. Thanks Stephen for catching this and Andrew for fixing. Sorry.

	Cyrill
