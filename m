Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab1JGUiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:38:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038Ab1JGUef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:34:35 -0400
Date: Fri, 7 Oct 2011 22:34:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Temporary location for hid, apm and trivial trees
In-Reply-To: <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1110072228400.14901@pobox.suse.cz>
References: <alpine.LNX.2.00.1109141520450.13109@pobox.suse.cz> <20110915000759.44ec63c0f9a3d68239886de5@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Stephen Rothwell wrote:

> > temporary locations for hid, apm and trivial trees until kernel.org 
> > reappears, are
> > 
> > 	git://twin.jikos.cz/jikos/hid
> > 	git://twin.jikos.cz/jikos/apm
> > 	git://twin.jikos.cz/jikos/trivial
> 
> I am assuming the for-next branch of each.  However, fetching the trivial
> tree fails with:
> 
> fatal: The remote end hung up unexpectedly
> 
> I will switch to these tomorrow (assuming that you fix the trivial tree).

Hi Stephen,

I have now switched back to kernel.org with my trees. So please from now 
on, use again

	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git
	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git

particularly for-next branch of those.

I will keep pushing both to kernel.org and the temporary location at my 
sever for some time still, but I'd like to make kernel.org ones the 
'correct' ones from now on.

Thanks,

-- 
Jiri Kosina
SUSE Labs
