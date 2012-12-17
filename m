Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab2LQCws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 21:52:48 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:33809 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2LQCwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 21:52:47 -0500
X-ASG-Debug-ID: 1355712763-0421b549eb996d0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sun, 16 Dec 2012 21:52:41 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Chris Mason <clmason@fusionio.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <JBacik@fusionio.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the btrfs tree
Message-ID: <20121217025241.GC13828@shiny>
X-ASG-Orig-Subj: Re: linux-next: build failure after merge of the btrfs tree
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Chris Mason <clmason@fusionio.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Stefan Behrens <sbehrens@giantdisaster.de>,
	Josef Bacik <JBacik@fusionio.com>,
	Linus <torvalds@linux-foundation.org>
References: <20121217100022.7d751dc9075d60a33d636a23@canb.auug.org.au>
 <20121217001504.GA13828@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121217001504.GA13828@shiny>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355712763
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.01
X-Barracuda-Spam-Status: No, SCORE=0.01 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA_TO_FROM_DOMAIN_MATCH
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117227
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 BSF_SC0_SA_TO_FROM_DOMAIN_MATCH Sender Domain Matches Recipient
	                           Domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 05:15:04PM -0700, Chris Mason wrote:
> On Sun, Dec 16, 2012 at 04:00:22PM -0700, Stephen Rothwell wrote:
> Josef and I have sob on all of our commits (at least all the ones not in
> 3.7, I didn't go back farther).  In this case the Author was Stefan and
> it ended up rebased in either Josef's or my tree.  We usually try to
> preserve merges on rebase, but this time was a bigger set of changes
> than usual and it didn't work out.

Just FYI, I've pushed out a fixed version of the tree with proper
signed-off-by on all the commits, thanks for catching that.

It also has the fix for the ppc compile problems.  (This isn't a pull
request yet, I've got the hash collision fix and a few others pending as
well).

-chris

