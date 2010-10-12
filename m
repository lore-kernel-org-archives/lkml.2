Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0JLRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:02:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40640 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0JLRCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:02:18 -0400
Date: Tue, 12 Oct 2010 19:02:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrus Massoumi <cyrusm@gmx.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Scalability to 48 cores
Message-ID: <20101012170210.GI20436@basil.fritz.box>
References: <4CB381DB.1040206@gmx.net>
 <87wrpn1nwy.fsf@basil.nowhere.org>
 <585FC89B-C279-485E-9AE4-6ABA0F5EE4CE@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <585FC89B-C279-485E-9AE4-6ABA0F5EE4CE@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 12:00:27PM -0400, Theodore Tso wrote:
> 
> On Oct 12, 2010, at 10:33 AM, Andi Kleen wrote:
> 
> > The paper is known, but it seems to be in the usual unproductive 
> > "publish a paper, but don't care about fixing anything" acedemic mode.
> 
> The thing I found most disappointing about the paper is that it describe techniques that have been in use in industry to provide better scalability to commerical OS's, and which were first applied to Linux something like a decade ago.


I haven't gone fully through it yet, maybe there are still some useful
nuggets in there. I would help if they published their patches though.

They used a few new workloads which were useful I guess.

> It's just that a lot of scalability work took a bit of a hiatus, oh, five years ago because at the time, Linux was good enough, and adding more scalability has costs (which is why not all of the changes SGI made for 512 and 1024-way scalability have not necessarily found their way into mainline).   The fact that we've needed to worry about scalability now that 6+ cores/socket are available now, and many more are coming soon, is something we've known for at least the last year or two. 

Already at 8*2 and 12 cores/socket

Fully agreed, but the other aspect is that we also need to worry
now about TBs and more of memory on a single (non extreme) system

More cores come with more memory and now even with 4K pages.

As a simple exercise I configured a 1TB system for less than 50kEUR
at Dell.com some time ago: that's not cheap, but definitely not
an exotic super computer either and prices will go down.

I believe a lot of new challenges also come from that, although
there has been a lot less work on that so far than on core scalability.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
