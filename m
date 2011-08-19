Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1HSAsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:48:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58662 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1HSAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:48:36 -0400
Subject: Re: +
 prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision .patch
 added to -mm tree
From: Kay Sievers <kay.sievers@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, roland@hack.frob.com
Date: Fri, 19 Aug 2011 02:48:31 +0200
In-Reply-To: <CA+55aFyFnMRMuWSSpytwvpk9u5YysMRfTRELyhGX9grWbGyi6Q@mail.gmail.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
	 <20110817115543.GA8745@redhat.com>
	 <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
	 <20110817134516.GA14136@redhat.com>
	 <20110818124353.GA2839@tango.0pointer.de>
	 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
	 <CA+55aFxGDbNOhNQJe_LpUMcJCGcW8qFFWzC9H0_KW26Xzb0cXw@mail.gmail.com>
	 <1313704516.15082.5.camel@mop>
	 <CA+55aFyFnMRMuWSSpytwvpk9u5YysMRfTRELyhGX9grWbGyi6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313714913.29251.7.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 15:22 -0700, Linus Torvalds wrote:
> On Thu, Aug 18, 2011 at 2:55 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> > It will be used for all new service managers. UNIX is a pain if you want
> > to watch your children regarding double-forking, if you are not init.
> 
> I'll believe that "all new service managers" when I see it. Until
> then, a new feature is just that - a new feature. Which nobody uses.

That feature will be used in Fedora 17 if we get that properly working.
Promised!

So far we have a pretty good track record in immediately using the stuff
we add to the kernel. People working on the other side usually complain
that we always require such new kernels. :)

> > If you want, we can make the forked processes inherit a flag if the
> > 'subreaper' should be looked up at all. Then we have almost zero
> > overhead if the feature isn't used. You think that's needed?
> 
> Yes, I do. Because with any current system, that "almost zero
> overhead" is just totally wasted effort entirely for zero gain. Which
> just makes me go "Eww".

Yeah, understood. I'll change it with the next round, and we can see how
to go from there.

Thanks,
Kay

