Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2BQWnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:43:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57476 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab2BQWnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:43:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.134.198 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 14:42:31 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Holger Macht <holger@homac.de>
cc: Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
In-Reply-To: <20120217222922.GA2741@homac.suse.de>
Message-ID: <alpine.LSU.2.00.1202171436490.10222@eggly.anvils>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils> <20120217222922.GA2741@homac.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012, Holger Macht wrote:
> On Fr 17. Feb - 13:46:04, Hugh Dickins wrote:
> > Matthew,
> > 
> > A linux-next oops at bootup in dock_link_device() tells me that you
> > were not feeling well when you wrote that and dock_unlink_device():
> > I hope you're feeling better now and can rewrite them soon.
> 
> Andrew Morton experienced a similar problem. What system are you using?
> I didn't encounter this problem with the systems I tested with.

The two systems I got that on were both 4-year-old Core2 Duo systems,
one an HP quad desktop, one a Fujitsu-Siemens laptop.

> 
> Do you actually have a /sys/devices/platform/dock.?/ directory with a
> file 'type' that contains 'dock_station'?

I'll have to report back on that this evening, I'm away from them now.

Hugh
