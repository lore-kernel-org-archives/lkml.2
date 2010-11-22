Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0KVBqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:46:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48002 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0KVBqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:46:32 -0500
Date: Sun, 21 Nov 2010 17:44:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, catalin.marinas@arm.com,
        linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Revert
 "kconfig: Temporarily disable dependency warnings"
Message-Id: <20101121174456.c6f77f56.randy.dunlap@oracle.com>
In-Reply-To: <20101122114801.2eee4c4d.sfr@canb.auug.org.au>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 11:48:01 +1100 Stephen Rothwell wrote:

> On Fri, 29 Oct 2010 11:37:31 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 12 Oct 2010 15:19:46 +0200 Michal Marek <mmarek@suse.cz> wrote:
> > >
> > > This reverts commit 71ebc01, which was a 2.6.36-only stopgap solution.
> > 
> > I was hoping that we would have the number of these warnings down to
> > something reasonable before this revert made it into Linus' tree ...
> > 
> > I guess fixing the V4L stuff will become a bit more urgent, now :-)
> 
> Is there any chance that the V4L kconfig warnings will be fixed?  It is
> quite irritating for those of us who do allmodconfig (and allyesconfig)
> builds ...

Yes, the MEDIA kconfig warnings are irritating.
I just use "grep -v MEDIA" to ignore them.  :)

I haven't seen any email from Michal for more than one week.
Hopefully he will be back soon.

There are patches from Arnaud Lacombe <lacombar@gmail.com>
to introduce a VISIBLE property for kconfig symbols (this fixes the
MEDIA kconfig warnings), but Michal has not commented on them.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
