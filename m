Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab1FFWlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:41:37 -0400
Received: from fieldses.org ([174.143.236.118]:40097 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229Ab1FFWlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:41:35 -0400
Date: Mon, 6 Jun 2011 18:41:31 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] nfsd: v4 support requires CRYPTO
Message-ID: <20110606224131.GE1151@fieldses.org>
References: <20110603174528.GA1368@animx.eu.org>
 <20110606112217.9648b8ff.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606112217.9648b8ff.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:22:17AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> nfsd V4 support uses crypto interfaces, so select CRYPTO
> to fix build errors in 2.6.39:

Thanks, applying for 3.0.--b.

> 
> ERROR: "crypto_destroy_tfm" [fs/nfsd/nfsd.ko] undefined!
> ERROR: "crypto_alloc_base" [fs/nfsd/nfsd.ko] undefined!
> 
> Reported-by: Wakko Warner <wakko@animx.eu.org>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: stable@kernel.org
> ---
>  fs/nfsd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.39.orig/fs/nfsd/Kconfig
> +++ linux-2.6.39/fs/nfsd/Kconfig
> @@ -82,6 +82,7 @@ config NFSD_V4
>  	select NFSD_V3
>  	select FS_POSIX_ACL
>  	select SUNRPC_GSS
> +	select CRYPTO
>  	help
>  	  This option enables support in your system's NFS server for
>  	  version 4 of the NFS protocol (RFC 3530).
