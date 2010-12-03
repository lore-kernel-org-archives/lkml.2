Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0LCF5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:57:24 -0500
Received: from 1wt.eu ([62.212.114.60]:48323 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0LCF5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:57:23 -0500
Date: Fri, 3 Dec 2010 06:52:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux stable kernel release procedure changes
Message-ID: <20101203055258.GB29279@1wt.eu>
References: <20101203004247.GA21762@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203004247.GA21762@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Dec 02, 2010 at 04:42:47PM -0800, Greg KH wrote:
> I'm doing this as it's just way too confusing to try to explain to
> people exactly what kernels are being maintained longer than others, and
> why they are being maintained.  Not to mention the confusion on the
> kernel.org web site where it's hard to tell what kernel release is
> currently being maintained or not.

I'm just thinking that maybe the kernel.org site could reflect only
the versions for which a "LATEST-IS" entry exists. That way, it's
easy to remove old files when an old kernel is not supported anymore.

> I think this is a good thing and will help both the community and
> developers get back on track and focusing on the latest releases and not
> needlessly waste their time on years old kernels that only distros care
> about.

I'd say that not only distros care about them, your support of 2.6.27
is very much appreciated by people who have to install and maintain
servers they can't afford to upgrade every month. But I certainly
understand the amount of work it represents and when I see you post
500 patches at once, I always wonder how much time it takes to you
to prepare that, and whether you're going to blow a fuse or not !

> I already have someone lined up who wants to maintain the .35 kernel in
> a longterm manner that I trust, Andi Kleen, and I'll let him write to
> explain his goals for this kernel and what he's going to do.

Good news !

> Also, as many people have asked about this in the past, I'm now happy to
> announce that the stable@kernel.org email address is now a mailing list
> that anyone can subscribe to in order to see the patches that are sent
> to it, if they wish to comment or maintain their own kernel tree.  I
> will warn you, it's pretty boring, and high volume at times, but hey,
> it's better to work in the open as that's how we need to operate.

Ah that's really nice. I've been following your announces to pick/review
patches there, now I won't bother you to know if you got patch X or Y :-)
BTW I think we should be careful not to discuss too much on the list in
order not to pollute it, otherwise some patches risk to be lost.

Thanks!
Willy

