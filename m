Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0KVCK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:10:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63325 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0KVCKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:10:54 -0500
Date: Sun, 21 Nov 2010 18:09:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        catalin.marinas@arm.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Revert
 "kconfig: Temporarily disable dependency warnings"
Message-Id: <20101121180941.16d787ab.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe wrote:

> Hi,
> 
> On Sun, Nov 21, 2010 at 7:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Fri, 29 Oct 2010 11:37:31 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>
> >> On Tue, 12 Oct 2010 15:19:46 +0200 Michal Marek <mmarek@suse.cz> wrote:
> >> >
> >> > This reverts commit 71ebc01, which was a 2.6.36-only stopgap solution.
> >>
> >> I was hoping that we would have the number of these warnings down to
> >> something reasonable before this revert made it into Linus' tree ...
> >>
> >> I guess fixing the V4L stuff will become a bit more urgent, now :-)
> >
> > Is there any chance that the V4L kconfig warnings will be fixed?  It is
> > quite irritating for those of us who do allmodconfig (and allyesconfig)
> > builds ...
> >
> There is 2 patches which fixes that by adding to the kconfig language
> a "visible" property to menus, 1 revert of "another" solution (which
> works but does not scale) and 2 patch which makes usage of the new
> property. Ack-ed and complemented by Mauro, but still waiting
> review/blessing by Michal.
> 
> The core change is available here: https://patchwork.kernel.org/patch/306412/
> 
> Alternatively, if you don't care about the menu structure, Randy
> proposed a one-liner.

which Mauro nacked.

I don't care about the menu structure, I just want to eliminate the
warnings.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
