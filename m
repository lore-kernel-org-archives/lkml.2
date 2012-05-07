Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2EGOPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:15:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48788 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2EGOPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:15:31 -0400
MIME-Version: 1.0
Message-ID: <1eb6ed43-f128-40cd-b9e6-e8578cf7cbdd@default>
Date: Mon, 7 May 2012 07:14:38 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Sasha Levin <levinsasha928@gmail.com>, gregkh@linuxfoundation.org,
        dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH v2] ramster: depend on NET for sock_* functions
References: <<1336388542-8624-1-git-send-email-levinsasha928@gmail.com>>
In-Reply-To: <<1336388542-8624-1-git-send-email-levinsasha928@gmail.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Sent: Monday, May 07, 2012 5:02 AM
> To: gregkh@linuxfoundation.org; dan.magenheimer@oracle.com; sjenning@linux.vnet.ibm.com
> Cc: linux-kernel@vger.kernel.org; Sasha Levin
> Subject: [PATCH v2] ramster: depend on NET for sock_* functions
> 
> Building ramster without NET would cause linkage issue due to missing
> sock_*() functions in cluster/tcp.c
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Thanks Sasha!

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/ramster/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
> index 4af1f8d..8e334cb 100644
> --- a/drivers/staging/ramster/Kconfig
> +++ b/drivers/staging/ramster/Kconfig
> @@ -1,6 +1,6 @@
>  config RAMSTER
>  	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
> -	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
> +	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && NET
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
>  	default n
> --
> 1.7.8.5
