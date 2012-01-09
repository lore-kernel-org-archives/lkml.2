Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2AIPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:50:21 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:53342 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab2AIPuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:50:18 -0500
Date: Mon, 9 Jan 2012 10:50:16 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Shantanu Goel <sgoel01@yahoo.com>
Cc: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix up range_end offset in range cyclic writeback
Message-ID: <20120109155016.GD22175@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Shantanu Goel <sgoel01@yahoo.com>,
	Kernel <linux-kernel@vger.kernel.org>
References: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com>
 <20120109151707.GB22175@thunk.org>
 <1326123988.9602.YahooMailNeo@web38004.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326123988.9602.YahooMailNeo@web38004.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 07:46:28AM -0800, Shantanu Goel wrote:
> 
> Thanks for confirming the fix is good.  We noticed that kupdate
> writebacks were happening at irregular intervals

So this was a performance issue that led you to this investigation?
How much of a performance issue are we talking about?

If it's a correctness issue that might lead to data loss because
fsync() wasn't doing its jobs, that's obviously higher priority than a
performance issue.

Again, I just wanted to characterize this correctly in the commit ---
BTW, this is good stuff to include in the commit description so in the
future, developers trying to go through the history can understand why
a particular patch is important (perhaps to backport into an
enterprise distro release, etc.)

Thanks, regards,

						- Ted
