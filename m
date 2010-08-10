Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0HJLW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:22:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:50919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458Ab0HJLWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:22:50 -0400
Date: Tue, 10 Aug 2010 13:22:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Christoph Egger <siccegge@cs.fau.de>
Subject: Re: linux-next: manual merge of the trivial tree with Linus' tree
In-Reply-To: <20100810121117.8710aa26.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1008101322260.29919@pobox.suse.cz>
References: <20100810121117.8710aa26.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/mach-omap1/board-nokia770.c between commit
> ab6f7751905e5cf713d081dbb3b97b8f6909ab34 ("Removing dead OMAP_DSP") from
> Linus' tree and commit 426d31071ac476ea62c62656b242930c17b58c00 ("fix
> printk typo 'faild'") from the trivial tree.
> 
> The former removes the code that the latter is updating.  So I just
> removed it.

Hi Stephen,

I have now merged Linus' master into for-next branch, so this conflict 
should now be gone.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
