Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab0DIDXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:23:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52739 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0DIDXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:23:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Apr 2010 12:20:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       stable@kernel.org
Subject: Re: [PATCH] fix cgroup procs documentation
Message-Id: <20100409122001.60967001.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BBE9D58.2010602@cn.fujitsu.com>
References: <20100409121143.9610dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<4BBE9D58.2010602@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 11:22:00 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > 2.6.33's Documentation has the same wrong information. So, I CC'ed to stable.
> > If people believe this information, they'll usr cgroup.procs file and will
> > see cgroup doesn'w work as expected.
> > The patch itself is against -mm.
> > 
> > ==
> > Writing to cgroup.procs is not supported now.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  Documentation/cgroups/cgroups.txt |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > Index: mmotm-temp/Documentation/cgroups/cgroups.txt
> > ===================================================================
> > --- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
> > +++ mmotm-temp/Documentation/cgroups/cgroups.txt
> > @@ -235,8 +235,7 @@ containing the following files describin
> >   - cgroup.procs: list of tgids in the cgroup.  This list is not
> >     guaranteed to be sorted or free of duplicate tgids, and userspace
> >     should sort/uniquify the list if this property is required.
> > -   Writing a tgid into this file moves all threads with that tgid into
> > -   this cgroup.
> > +   This is a read-only file, now.
> 
> I think the better wording is "for now". :)
> 
ok. BTW, does anyone work on this ?
==

Writing to cgroup.procs is not supported now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: mmotm-temp/Documentation/cgroups/cgroups.txt
===================================================================
--- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
+++ mmotm-temp/Documentation/cgroups/cgroups.txt
@@ -235,8 +235,7 @@ containing the following files describin
  - cgroup.procs: list of tgids in the cgroup.  This list is not
    guaranteed to be sorted or free of duplicate tgids, and userspace
    should sort/uniquify the list if this property is required.
-   Writing a tgid into this file moves all threads with that tgid into
-   this cgroup.
+   This is a read-only file, for now.
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)

