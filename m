Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1HDWFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:05:33 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55431 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755795Ab1HDWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:05:26 -0400
Date: Thu, 4 Aug 2011 15:05:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nitin Gupta <ngupta@vflare.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] zcache: Fix build error when sysfs is not defined
Message-Id: <20110804150524.2dcfcecf.rdunlap@xenotime.net>
In-Reply-To: <1297484079-12562-1-git-send-email-ngupta@vflare.org>
References: <1297484079-12562-1-git-send-email-ngupta@vflare.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 23:14:39 -0500 Nitin Gupta wrote:

> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  drivers/staging/zcache/zcache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
> index 61be849..8cd3fd8 100644
> --- a/drivers/staging/zcache/zcache.c
> +++ b/drivers/staging/zcache/zcache.c
> @@ -1590,9 +1590,9 @@ __setup("nofrontswap", no_frontswap);
>  
>  static int __init zcache_init(void)
>  {
> -#ifdef CONFIG_SYSFS
>  	int ret = 0;
>  
> +#ifdef CONFIG_SYSFS
>  	ret = sysfs_create_group(mm_kobj, &zcache_attr_group);
>  	if (ret) {
>  		pr_err("zcache: can't create sysfs\n");
> -- 

OMG.  This patch still needs to be applied to linux-next 20110804..........
sad.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
