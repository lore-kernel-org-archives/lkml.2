Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1BJGio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:38:44 -0500
Received: from 1wt.eu ([62.212.114.60]:60461 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1BJGin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:38:43 -0500
Date: Thu, 10 Feb 2011 07:38:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.27.58
Message-ID: <20110210063837.GI16288@1wt.eu>
References: <20110209220430.GA17820@hera.kernel.org> <1297315686.7996.50.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297315686.7996.50.camel@marge.simson.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Feb 10, 2011 at 06:28:06AM +0100, Mike Galbraith wrote:
> On Wed, 2011-02-09 at 22:04 +0000, Willy Tarreau wrote:
> > I've just released Linux 2.6.27.58.
> 
> For users of 27 who wish the scheduler had a bit less overhead, attached
> is a small set of sched patches I considered mandatory for my 27 tree.
> First patch cuts overhead quite a bit, the others are just fixes I
> considered important enough to carry around.
> 
> I'm not proposing inclusion, just making it available once because I
> happened to notice this release message, and thought of some issues.

That's very kind of you, I appreciate it. Indeed, it can interest some
users. I too would rather avoid to merge them, since scheduler changes
can improve some workloads and cause unexpected regressions in other
ones. However, if people insist and only report positive feedback, we
might possibly consider them. I'll definitely test them in my tree ;-)

Thanks!
Willy

