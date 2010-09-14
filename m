Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0INXPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:15:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0INXPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:15:43 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Florian Mickler <florian@mickler.org>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <m1lj749ra2.fsf@fess.ebiederm.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100911001350.GA11478@infradead.org>
	 <1284165074.1783.213.camel@Joe-Laptop>
	 <20100911004550.GA30584@infradead.org>
	 <20100911112855.6ee6e929@schatten.dmk.lab>
	 <m1hbhucdv5.fsf@fess.ebiederm.org> <1284364665.22185.116.camel@Joe-Laptop>
	 <20100913105434.62b150f7@schatten.dmk.lab>
	 <m1lj749ra2.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 16:15:41 -0700
Message-ID: <1284506141.26719.137.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 10:19 -0700, Eric W. Biederman wrote:
> Florian Mickler <florian@mickler.org> writes:
> > On Mon, 13 Sep 2010 00:57:45 -0700
> > Joe Perches <joe@perches.com> wrote:
> >> On Mon, 2010-09-13 at 00:16 -0700, Eric W. Biederman wrote:
> >> > It is trivial for a human to look at a git log and see which changes
> >> > were just global cleanups and which changes were actual maintenance.
> >> > Apparently get_maintainers doesn't have that ability.
> >> Do you have a useful, trivial or non-trivial algorithm
> >> to suggest or is that soft commenting?  All I'll say is
> >> AI can be a surprisingly difficult field.
> > :) indeed. 
> Which is why the tool needs to assist a person in doing the work.
> Please deliver a tool and not a broken solution.

Please suggest or implement improvements instead of merely asking
for something better.

> > It is easy to make get_maintainer.pl output less people. 
> > What is not easy is to get it to decrease false-positives while
> > not decreasing it's detection rate. 
> What is needed is something other than output that is a list of
> email addresses.

> email address foo had x% of non-author signed off bys
> email address foo had y% of author signed off bys
> email address foo had y% of author commits.
> email address foo came from the Maintainers file.

Already implemented.

Use --git --rolestats

> Additionally for email addresses that hit less often a list
> of patch subject titles, and truncated sha1 patch ids.  So
> with luck you can tell at a glance the person is of interest
> and if not you can look at their commits quickly and see.

Use git.  There's no reason to reimplement what git does.

> Which means in time every long time developer will be copied on every
> patch.

No, it doesn't mean that.  Inactive developers don't get listed
by the tool.

> And right now get_maintainer.pl is decreasing the relevancy of cc lines
> in commits, which if get_maintainers.pl is used enough could be a
> vicious circle.

I don't see that get_maintainer does what you suggest it does.
Find some examples and publish them.


