Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0KAQXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0KAQX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:23:28 -0400
Date: Mon, 1 Nov 2010 12:23:15 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: sfrench@samba.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linux-cifs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/1] FS: cifs, remove unneeded NULL tests
Message-ID: <20101101122315.5bcf6bac@tlielax.poochiereds.net>
In-Reply-To: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
References: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Nov 2010 16:08:55 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
> cifs_user_write are dereferenced prior their test to NULL.
> 
> The alternative is not to dereference them before the tests. The patch is
> to point out the problem, you have to decide.
> 
> While at it we cache the inode in cifs_user_write to a local variable
> and use all over the function.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Steve French <sfrench@samba.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  fs/cifs/file.c  |   25 +++++++++++--------------
>  fs/cifs/ioctl.c |    4 ----
>  2 files changed, 11 insertions(+), 18 deletions(-)
> 

Reviewed-by: Jeff Layton <jlayton@redhat.com>
