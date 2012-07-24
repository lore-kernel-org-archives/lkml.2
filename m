Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2GXTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:21:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41015 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab2GXTVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:21:36 -0400
Date: Tue, 24 Jul 2012 15:21:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Bob Liu <lliubbo@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, vapier@gentoo.org,
        sonic.zhang@analog.com
Subject: Re: [GIT PULL v2] Blackfin changes for 3.6-rc1
Message-ID: <20120724192120.GB29239@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Bob Liu <lliubbo@gmail.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org, vapier@gentoo.org,
	sonic.zhang@analog.com
References: <1343109280-22653-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343109280-22653-1-git-send-email-lliubbo@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 01:54:40PM +0800, Bob Liu wrote:
> 
> This is the new pull request about blackfin changes for 3.6-rc1.
> I've rebased my tree to 3.5.

To save Linus having to send you a chastising e-mail (and because I'll
probably be more gentle about it than he would be :-), in general it's
good not to rebase your the tree before submitting to Linus.  If you
tested with your set of commits pon top of 3.5-rc3, then submit those
patches that way.  Rebasing at least partially invalidates your
testing, and causes other problems if someone else has based their
tree off of yours.

If the goal is to avoid merge conflicts, it's better to just resolve
the conflict, and push the proposed merge resolution, and send Linus
both the commit pre-merge, and post-merge, and let him decide if wants
to use your merge resolution, or to fix things up in a slightly
different way.

Regards,

						- Ted
