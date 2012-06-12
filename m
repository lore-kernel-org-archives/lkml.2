Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2FLGHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:07:08 -0400
Received: from natasha.panasas.com ([67.152.220.90]:43660 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2FLGHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:07:07 -0400
Message-ID: <4FD6DC7A.9000709@panasas.com>
Date: Tue, 12 Jun 2012 09:06:50 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>, <osd-dev@open-osd.org>,
        Benny Halevy <bhalevy@tonian.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] exofs: fix sparse non-ANSI function warning
References: <4FD6836F.1020406@xenotime.net>
In-Reply-To: <4FD6836F.1020406@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 02:46 AM, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix sparse non-ANSI function warning:
> 
> fs/exofs/sys.c:112:28: warning: non-ANSI function declaration of function 'exofs_sysfs_dbg_print'
> 


Thanks, will push for 3.6 merge window. Might take me
a few days to push to linux-next

Boaz

> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  fs/exofs/sys.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-35-rc2.orig/fs/exofs/sys.c
> +++ lnx-35-rc2/fs/exofs/sys.c
> @@ -109,7 +109,7 @@ static struct kobj_type odev_ktype = {
>  static struct kobj_type uuid_ktype = {
>  };
>  
> -void exofs_sysfs_dbg_print()
> +void exofs_sysfs_dbg_print(void)
>  {
>  #ifdef CONFIG_EXOFS_DEBUG
>  	struct kobject *k_name, *k_tmp;


