Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab1DHXIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:08:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:34257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab1DHXIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:08:20 -0400
Date: Fri, 8 Apr 2011 16:08:17 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
        Trivial patches <trivial@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] ufs: Fix a typo
In-Reply-To: <1302283987-22248-1-git-send-email-abogani@kernel.org>
Message-ID: <alpine.LNX.2.00.1104081608010.6022@pobox.suse.cz>
References: <1302283987-22248-1-git-send-email-abogani@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Alessio Igor Bogani wrote:

> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---
>  fs/ufs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
> index 27a4bab..c72b6ce 100644
> --- a/fs/ufs/inode.c
> +++ b/fs/ufs/inode.c
> @@ -409,7 +409,7 @@ out:
>  }
>  
>  /**
> - * ufs_getfrag_bloc() - `get_block_t' function, interface between UFS and
> + * ufs_getfrag_block() - `get_block_t' function, interface between UFS and

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
