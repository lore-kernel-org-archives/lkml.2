Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1GFQAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:00:18 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:44255 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754037Ab1GFQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:00:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iQzdmdOmn+IvUACi7Zm2t5WWNaeBCmdMmu2k9uhewh/QrFtQfW8KQoCUC2q3T1VEqG+xVlm+0+20W6Rcof+AlGvZLfvr1YNqAql0K+XdLbZjKmFDiRiw1xNhGjcXDFGZ;
Date: Wed, 6 Jul 2011 09:00:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Fixup kerneldoc for generic_permission()
Message-Id: <20110706090014.d46bbbe3.rdunlap@xenotime.net>
In-Reply-To: <1309520691-17741-1-git-send-email-tklauser@distanz.ch>
References: <1309520691-17741-1-git-send-email-tklauser@distanz.ch>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Jul 2011 13:44:51 +0200 Tobias Klauser wrote:

> The flags parameter went away in
> 5c90c1601f00154f8695951469f25f33579272ed

What git tree is that commit ID in?

This patch applies to linux-next, right?

> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  fs/namei.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index f181e4c..73fc34a 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -213,7 +213,6 @@ other_perms:
>   * generic_permission -  check for access rights on a Posix-like filesystem
>   * @inode:	inode to check access rights for
>   * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
> - * @flags:	IPERM_FLAG_ flags.
>   *
>   * Used to check for read/write/execute permissions on a file.
>   * We use "fsuid" for this, letting us set arbitrary permissions
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
