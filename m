Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1GVXt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:49:26 -0400
Received: from fieldses.org ([174.143.236.118]:44448 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1GVXtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:49:25 -0400
Date: Fri, 22 Jul 2011 19:49:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: NeilBrown <neilb@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110722234921.GE10749@fieldses.org>
References: <m2pql2c0qz.fsf@firstfloor.org>
 <20110722163335.2df4f6ca@notabene.brown>
 <1311363269.14555.261.camel@calx>
 <20110722205922.GS8006@one.firstfloor.org>
 <1311369102.14555.268.camel@calx>
 <20110722214732.GW8006@one.firstfloor.org>
 <20110722221039.GB10749@fieldses.org>
 <20110722223158.GC10749@fieldses.org>
 <20110723085915.308ddc02@notabene.brown>
 <20110722230612.GD10749@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722230612.GD10749@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 07:06:12PM -0400, J. Bruce Fields wrote:
> On Sat, Jul 23, 2011 at 08:59:15AM +1000, NeilBrown wrote:
> > But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> > more-generally-useful precise timestamps?
> 
> It *seems* like a generally useful idea, but I don't know of any other
> users.

(Out of curiosity: what actually *needs* real timestamps?:
	- They're generally useful to people, of course; ("what did I
	  change last tuesday?")
	- Make uses them, though in theory perhaps it could do the same
	  job by caching records like "object X was built from
	  versions a, b, and c of objects A, B, and C respectively".

But a lot of uses are probably just to answer the question "did this
file change since the last time I looked at it"?

Of course, however theoretically useful, there's always the argument
that linux-specific interfaces are unlikely to be used by anyone except
Lennart Poettering.)

--b.
