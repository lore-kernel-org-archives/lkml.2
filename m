Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab2EUO1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:27:54 -0400
Received: from 1wt.eu ([62.212.114.60]:2411 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab2EUO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:27:53 -0400
Date: Mon, 21 May 2012 16:27:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.2.18
Message-ID: <20120521142742.GC9099@1wt.eu>
References: <1337608943.10262.10.camel@deadeye> <CAFLxGvzdyr08UjHy_85CeHV=bB2nzzTy0JOdgLFx6x3mwOasdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzdyr08UjHy_85CeHV=bB2nzzTy0JOdgLFx6x3mwOasdw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:18:40PM +0200, richard -rw- weinberger wrote:
> On Mon, May 21, 2012 at 4:02 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> > I'm announcing the release of the 3.2.18 kernel.
> >
> > All users of the 3.2 kernel series should upgrade.
> 
> Should or must?
> IOW does it contain security fixes?

"security fixes" is a nebulous concept. I tend to define security issues as
issues that can be triggerred on purpose once known, in other words, issues
whose risk of appearance suddenly changes once they're disclosed.

Based on this, one guy's stability bug is another guy's security issue. If
you're the only account allowed on your servers and a vulnerability allows
any local account to crash your RAID card by reading something in /proc,
this might not be a security issue for you, just an annoying bug. And if
your laptop's WiFi draws all the battery's power when receiving specially
crafted packets, you might consider this an annoying bug while a solar-
powered router operator will probably consider this a critical security
issue.

The best you can do is review the changelog to see whether you're affected
or not by what is fixed there.

Regards,
Willy

