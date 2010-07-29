Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0G2C4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:56:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44067 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0G2C4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:56:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Jul 2010 11:51:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ondrej Zary <linux@rainbow-software.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100729115142.00a83b40.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100729100626.945da6e1.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<201007282338.12098.linux@rainbow-software.org>
	<20100729100626.945da6e1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 10:06:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 28 Jul 2010 23:38:09 +0200
> Ondrej Zary <linux@rainbow-software.org> wrote:
> 
> > On Wednesday 28 July 2010 23:34:07 Rafael J. Wysocki wrote:
> > > On Wednesday, July 28, 2010, Ondrej Zary wrote:
> > > > Hello,
> > > > after very long bisection, I finally found what's causing memory
> > > > corruption during hibernation on my machine sice 2.6.31:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753
> > > >
> > > > It's commit c9e444103b5e7a5a3519f9913f59767f92e33baf (mm: reuse unused
> > > > swap entry if necessary).
> > > >
> > > > I don't know anything about swapping in Linux so I don't have a clue
> > > > what's wrong with that commit.
> > >
> > > Thanks for bisecting!
> > >
> > > This looks rather serious.  I'd be grateful from any clues from the mm guys
> > > involved (CCed).
> > >
> > > Do you use s2disk or the built-in hibernation code?
> > 
> > I use built-in code (echo disk >/sys/power/state). The machine has 256MB RAM 
> > and 256MB swap partition.
> > 

BTW, what happens at resume ? How to page-in and remap ?

Thanks,
-Kame





