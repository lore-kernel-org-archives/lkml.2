Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0K3QjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:39:12 -0500
Received: from xenotime.net ([72.52.115.56]:54105 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751525Ab0K3QjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:39:10 -0500
Date: Tue, 30 Nov 2010 08:39:08 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DOCUMENTATION: Correct inline docs to match parm name.
Message-Id: <20101130083908.0af69035.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1011300629580.21294@localhost6.localdomain6>
References: <alpine.DEB.2.00.1011300629580.21294@localhost6.localdomain6>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 06:31:07 -0500 (EST) Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   the actual parameter name is "parent", not "dparent".
> 
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 23702a9..eaebae4 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1485,7 +1485,7 @@ out:
>  /**
>   * d_validate - verify dentry provided from insecure source
>   * @dentry: The dentry alleged to be valid child of @dparent
> - * @dparent: The parent dentry (known to be valid)
> + * @parent: The parent dentry (known to be valid)
>   *
>   * An insecure source has sent us a dentry, here we verify it and dget() it.
>   * This is used by ncpfs in its readdir implementation.

I've already sent this patch to Al Viro (VFS maintainer).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
