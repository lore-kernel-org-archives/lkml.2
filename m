Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0LCVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:09:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:35907 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0LCVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:09:28 -0500
Date: Fri, 3 Dec 2010 16:07:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com
Cc: Andi Kleen <andi@firstfloor.org>, lwn@lwn.net
Subject: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101203210719.GB21223@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Dec 2010 21:07:20.0434 (UTC) FILETIME=[12DB6D20:01CB932E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, I'd like to thank Greg for all the past work he's done on
juggling all these different stable releases - many people have
reaped the benefits of them for quite some time, and it only makes
sense to spread the loading around as it has grown significantly.

With that in mind, it is our intention to also maintain a 2.6.34
longterm tree.  Jason and I work at Wind River, which already has
released products based on v2.6.34, and as such it only makes sense
to have a public long-term tree that others who are also based on
2.6.34 can make use of.

I've already done an end-to-end audit of the current 2.6.32 longterm
stable release, and used the list of these already "approved for stable"
patches on v2.6.32 to identify 260 upstream commits that are applicable,
but not yet present in the last 2.6.34.7 stable release.

A candidate tree for 2.6.34.8 with the above 260 commits applied to
it is available now for review/testing at:

   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-2.6.34.y.git

Note that there are no additional "non-stable" commits applied to this
tree.  It is purely commits that are already in use in a stable release.
The next step will be to audit the 35-stable for appropriate content.

This tree is currently undergoing internal testing at WR on various
x86[64], ARM, MIPS and PowerPC targets, but of course any additional
testing and feedback is most welcome.  If anyone is interested in the
audit data, I can send folks details on that too.

Just as with Andi's longterm tree, the final details of where these
will be finally located on kernel.org and so forth remains to be worked
out and will be announced at a later date as things are finalized.

Paul.
