Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0FFIGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:06:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:53249 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0FFIGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:06:42 -0400
Date: Sun, 6 Jun 2010 01:04:46 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <AANLkTinphtxn-8pGTYv_mBxKFMa7jU8i1yNbHrs50Vzl@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006060100290.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu> <AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com> <20100604075722.GA15181@elte.hu> <AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com> <20100604085513.GE15181@elte.hu>
 <AANLkTinphtxn-8pGTYv_mBxKFMa7jU8i1yNbHrs50Vzl@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010, Brian Swetland wrote:

> Yeah, I do understand that we're not making it easy for ourselves
> here.  I think we hit the point where Rafael and Matthew signed off on
> things and thought "aha, linux-pm maintainers are happy, now we're
> getting somewhere" only to realize the light at the end of the tunnel
> was a bit further out than we anticipated ^^

What you missed is that the linux-pm maintainers have relativly little 
weight in getting things into the kernel. They are gatekeeper, so until 
they approve it there is basically no chance of getting in, but even 
changes that they develop and push frequently have a uphill battle to get 
into the kernel, especially if they would end up touching all drivers. 
There have been several proposals by the pm team that have been shot down 
much more completely than wavelocks.

David Lang
