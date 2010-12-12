Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0LLWMD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:12:03 -0500
Received: from 1wt.eu ([62.212.114.60]:48559 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0LLWMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:12:01 -0500
Date: Sun, 12 Dec 2010 23:11:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Willy Tarreau is taking over the 2.6.27-longterm kernel release
Message-ID: <20101212221123.GA26949@1wt.eu>
References: <20101212190300.GB17174@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101212190300.GB17174@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:03:00AM -0800, Greg KH wrote:
> Hi all,
> 
> Just a short announcement to let everyone know that Willy Tarreau is
> taking over the 2.6.27-longterm kernel releases, now that I am finished
> with maintaining them.
> 
> Any questions/patches/concerns about this kernel tree should go to Willy
> from this point forward, not me.

Just to clarify the process, I'm going to maintain it at a much slower pace,
comparable to 2.4, which also means that anything other than important fixes
might get ignored. I'm using 2.6.27 in places where it's not acceptable to
reboot once a month to fix a bug, and my goal is to provide users who have
similar expectations with less common updates so that they have the time to
review and test them before upgrading.

Greg has done a amazing job on 2.6.27, which has gained an excellent level
of stability. I intend to use this to convince 2.4 users that a longterm
2.6 can match their expectations and that it's time to migrate. It will
then be easier to have them migrate between longterm releases once they
enter the process.

I've not decided how long I will maintain it, but at least it will last
longer than 2.4 so that users have the time to note the stability (or
to report bugs if any).

Thanks,
Willy

