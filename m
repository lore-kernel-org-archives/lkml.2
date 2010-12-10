Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0LJPHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:07:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0LJPHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:07:10 -0500
Date: Fri, 10 Dec 2010 16:07:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] anon_inodes: fix a typo in comment
In-Reply-To: <1291950710-5331-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.LNX.2.00.1012101606510.15140@pobox.suse.cz>
References: <1291950710-5331-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Namhyung Kim wrote:

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/anon_inodes.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index 57ce55b2564c..73097336ea2a 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -64,9 +64,9 @@ static const struct address_space_operations anon_aops = {
>  };
>  
>  /**
> - * anon_inode_getfd - creates a new file instance by hooking it up to an
> - *                    anonymous inode, and a dentry that describe the "class"
> - *                    of the file
> + * anon_inode_getfile - creates a new file instance by hooking it up to an
> + *                      anonymous inode, and a dentry that describe the "class"
> + *                      of the file
>   *
>   * @name:    [in]    name of the "class" of the new file
>   * @fops:    [in]    file operations for the new file

Obvious. Taking through trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
