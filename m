Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2JWO03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:26:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65129 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2JWO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:26:28 -0400
Message-ID: <5086A90E.1040007@gmail.com>
Date: Tue, 23 Oct 2012 10:26:22 -0400
From: Daniel Hazelton <dshadowwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: fengguang.wu@intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: Fix tools/vm/page-types.c
References: <20121023132007.32177.42349.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121023132007.32177.42349.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/12 09:20, David Howells wrote:
> Fix tools/vm/page-types.c to use the UAPI variant of linux/kernel-page-flags.h
> lest the following error appear:
>
> 	In file included from page-types.c:38:0:
> 	../../include/linux/kernel-page-flags.h:4:42: fatal error:
> 	uapi/linux/kernel-page-flags.h: No such file or directory
>
> Reported-by: Daniel Hazelton <dshadowwolf@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Fengguang Wu <fengguang.wu@intel.com>
> ---
>
>   tools/vm/page-types.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
> index cd1b03e..b76edf2 100644
> --- a/tools/vm/page-types.c
> +++ b/tools/vm/page-types.c
> @@ -35,7 +35,7 @@
>   #include <sys/mount.h>
>   #include <sys/statfs.h>
>   #include "../../include/uapi/linux/magic.h"
> -#include "../../include/linux/kernel-page-flags.h"
> +#include "../../include/uapi/linux/kernel-page-flags.h"
>
>
>   #ifndef MAX_PATH
>
>
FWIW: Tested-by: Daniel Hazelton <dshadowwolf@gmail.com>
