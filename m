Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0IMH5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:57:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1809 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0IMH5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:57:47 -0400
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
From: Joe Perches <joe@perches.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Florian Mickler <florian@mickler.org>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <m1hbhucdv5.fsf@fess.ebiederm.org>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100911001350.GA11478@infradead.org>
	 <1284165074.1783.213.camel@Joe-Laptop>
	 <20100911004550.GA30584@infradead.org>
	 <20100911112855.6ee6e929@schatten.dmk.lab>
	 <m1hbhucdv5.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 00:57:45 -0700
Message-ID: <1284364665.22185.116.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 00:16 -0700, Eric W. Biederman wrote:
> It is trivial for a human to look at a git log and see which changes
> were just global cleanups and which changes were actual maintenance.
> Apparently get_maintainers doesn't have that ability.

Do you have a useful, trivial or non-trivial algorithm
to suggest or is that soft commenting?  All I'll say is
AI can be a surprisingly difficult field.

> Have seen some files with something like 5 years of changes without a
> single commit by a maintainer and the only changes happening to it are
> global cleanup changes.

Then likely there's no actual maintainer for that file.

> If get_maintainers would look at MAINTAINERS and validate or invalidate
> that information by looking at git that would be useful.

Some entries in MAINTAINERS are outdated.
Validating MAINTAINERS entries is probably best done once.

I suggest you try that concept out, see what you get, and
make public the results.


