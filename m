Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0HKHig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:38:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:55674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab0HKHif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:38:35 -0400
Date: Wed, 11 Aug 2010 09:38:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the trivial tree with the vfs tree
In-Reply-To: <4C61D055.4090909@panasas.com>
Message-ID: <alpine.LNX.2.00.1008110938100.2702@pobox.suse.cz>
References: <20100810121900.cbceb878.sfr@canb.auug.org.au> <4C61D055.4090909@panasas.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Boaz Harrosh wrote:

> > Today's linux-next merge of the trivial tree got a conflict in
> > fs/exofs/inode.c between commit 21883a7d05d4c1e97943fa1a587aa2c2a3b09e8c
> > ("exofs: New truncate sequence") from the vfs tree and commit
> > 426d31071ac476ea62c62656b242930c17b58c00 ("fix printk typo 'faild'") from
> > the trivial tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry it for a
> > while.
> 
> The "exofs: New truncate sequence" is now in the Kernel. So perhaps
> fix printk typo 'faild'" could be rebased.
> 
> Or you can send the patch to me and I'll push it. Which ever you
> prefer

Thanks for notification, I have pulled Linus' branch now into 'for-next', 
so the conflict for linux-next should be gone.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
