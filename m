Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0KJWLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:11:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16018 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0KJWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:11:10 -0500
Date: Wed, 10 Nov 2010 22:59:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Oskar Schirmer <oskar@scara.com>
cc: Steve French <sfrench@samba.org>, stable@kernel.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [PATCH] cifs: fix another memleak, in cifs_root_iget
In-Reply-To: <1289423173-7044-1-git-send-email-oskar@scara.com>
Message-ID: <alpine.LNX.2.00.1011102257400.11302@swampdragon.chaosbits.net>
References: <1289423173-7044-1-git-send-email-oskar@scara.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Oskar Schirmer wrote:

> cifs_root_iget allocates full_path through
> cifs_build_path_to_root, but fails to kfree it upon
> cifs_get_inode_info* failure.
> 
> Make all failure exit paths traverse clean up
> handling at the end of the function.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: stable@kernel.org

I've reviewed your patch (although not actually tested it) and your 
changes look sane.
So, feel free to add

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

