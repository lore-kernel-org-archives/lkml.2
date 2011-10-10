Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1JJVvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:51:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab1JJVvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:51:45 -0400
Date: Mon, 10 Oct 2011 23:51:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Johann Felix Soden <johfel@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix file references in the whole tree
In-Reply-To: <4E934066.80109@xenotime.net>
Message-ID: <alpine.LNX.2.00.1110102350170.14768@pobox.suse.cz>
References: <1317683499.5990.2.camel@LAPJFS> <4E934066.80109@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Randy Dunlap wrote:

> From: Johann Felix Soden <johfel@users.sourceforge.net>
> Subject: [PATCH] Fix file references in the whole tree
> 
> There are a lot of file references to now moved or deleted files in the
> whole tree, especially in documentation and Kconfig files. This patch
> fixes many of them.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
> 
> Jiri, please merge.  I'll go thru the other changes separately.

This (and quite a lot more) has already been done by Paul Bolle, commit 
395cf9691d72 ("doc: fix broken references") in trivial.git.

-- 
Jiri Kosina
SUSE Labs
