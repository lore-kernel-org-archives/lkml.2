Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0LEBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 20:16:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:35948 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0LEBQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 20:16:56 -0500
Date: Sat, 4 Dec 2010 20:16:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101205011644.GB314@windriver.com>
References: <20101203210719.GB21223@windriver.com>
 <20101204172840.GC10282@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101204172840.GC10282@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Dec 2010 01:16:45.0527 (UTC) FILETIME=[15292670:01CB941A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: Announcement: Plans for v2.6.34-longterm] On 04/12/2010 (Sat 09:28) Greg KH wrote:

> On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
> > With that in mind, it is our intention to also maintain a 2.6.34
> > longterm tree.  Jason and I work at Wind River, which already has
> > released products based on v2.6.34, and as such it only makes sense
> > to have a public long-term tree that others who are also based on
> > 2.6.34 can make use of.
> 
> Other than Wind River, what other distros/userbases are using .34 as a
> platform for their products?

Well, since we create more of a distro builder, than a distro itself,
anyone who uses WR to in turn create a distro for their own hardware or
product will of course be using 2.6.34.  The Yocto project is currently
using the 2.6.34 kernel and I'm sure there are others I'm not
immediately aware of.

> And how long do you expect to be maintaining this .34 branch for?

The expectation is that maintenance will be ongoing for years, since
we'll largely be needing to do that work anyway.  I plan to follow your
lead on how you handled .27 -- i.e. the "early" releases will possibly
be rich with content, but as it gets to be closer to EOL (i.e. on the
order of 10 releases removed from current), then it will only be the key
CVE-like fixes and similar which will be added.

Paul.

> 
> curious,
> 
> greg k-h
