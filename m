Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1LVD1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:27:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53011 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab1LVD1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:27:13 -0500
Message-ID: <4EF2A410.6020400@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 11:29:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "nai.xia" <nai.xia@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree: delete orphaned macro radix_tree_indirect_to_ptr
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils> <20111221050740.GD23662@dastard> <alpine.LSU.2.00.1112202218490.4026@eggly.anvils> <20111221221527.GE23662@dastard> <alpine.LSU.2.00.1112211555430.25868@eggly.anvils> <4EF2A0ED.8080308@gmail.com>
In-Reply-To: <4EF2A0ED.8080308@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 11:26:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 11:26:30,
	Serialize complete at 2011-12-22 11:26:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nai.xia wrote:
> Seems nobody has been using the macro radix_tree_indirect_to_ptr()
> since long time ago. Delete it.
> 

Someone else has already posted the same patch.

https://lkml.org/lkml/2011/12/16/118

> Signed-off-by: Nai Xia <nai.xia@gmail.com>
> ---
>  include/linux/radix-tree.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -49,9 +49,6 @@
>  #define RADIX_TREE_EXCEPTIONAL_ENTRY    2
>  #define RADIX_TREE_EXCEPTIONAL_SHIFT    2
> 
> -#define radix_tree_indirect_to_ptr(ptr) \
> -    radix_tree_indirect_to_ptr((void __force *)(ptr))
> -
>  static inline int radix_tree_is_indirect_ptr(void *ptr)
>  {
>      return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
