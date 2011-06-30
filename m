Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1F3FWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:22:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:48814 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1F3FWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:22:43 -0400
Date: Thu, 30 Jun 2011 15:22:33 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        git@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the
  tree
In-Reply-To: <20110630142910.2fea4257.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1106301518430.13767@tundra.namei.org>
References: <20110630142910.2fea4257.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011, Stephen Rothwell wrote:

> I cannot merge commit bcd05ca10420 ("Merge branch 'for-security' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev into next")
> which is the child of the above two commits.

Actually, I may have accidentally pulled upstream commits in via the 
above.  I'll rebase my tree to the TOMOYO merge.


- James
-- 
James Morris
<jmorris@namei.org>
