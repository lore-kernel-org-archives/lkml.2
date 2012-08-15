Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2HOIXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:23:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28056 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2HOIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:23:24 -0400
Date: Wed, 15 Aug 2012 11:23:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: torvalds@linux-foundation.org, rdunlap@xenotime.net, tytso@mit.edu,
        alan@lxorguk.ukuu.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SubmittingPatches: clarify SOB tag usage when evolving
 submissions
Message-ID: <20120815082301.GA1359@mwanda>
References: <1344545493-6820-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344545493-6820-1-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it would be nice to have another tag for people who fix bugs
in the original patch.  The Reviewed-by tag implies approval of the
whole patch and anyway reviewers don't normally comment unless they
see a bug.  Maybe something like:

Contributor: Your Name <email@address.com>

So the tags for developers would be:

Signed-off-by:  The patch went through you.  Legal responsibility.
Acked-by:  You know what you are talking about and approve.
Reviewed-by:  You reviewed the patch and approve.
Contributor:  You noticed or fixed a bug in the patch.

regards,
dan carpenter
