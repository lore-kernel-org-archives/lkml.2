Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1G1Ete (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab1G1Eta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:49:30 -0400
Date: Thu, 28 Jul 2011 00:49:24 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: broken checkpatch signature checking
Message-ID: <20110728044924.GA21655@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110728043327.GA21448@redhat.com>
 <1311828102.10042.1.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311828102.10042.1.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 09:41:42PM -0700, Joe Perches wrote:
 > On Thu, 2011-07-28 at 00:33 -0400, Dave Jones wrote:
 > > The signature checking patches in commit 2011247550 have broken one use-case for me.
 > > I pipe the git-commits mailing list to it and skim the summary once a day[*]
 > > Because git indents its changelogs, every single commit is now warning
 > > with this..
 > > WARNING: Do not use whitespace before Signed-off-by:
 > > #5252:
 > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 > 
 > Hey Dave.
 > 
 > Maybe you could use --ignore=BAD_SIGN_OFF for this reviewing?

Ok, that works for me.  I guess I should add all the whitespace ignores while I'm at it.

thanks,

	Dave

