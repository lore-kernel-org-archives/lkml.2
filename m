Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1LVDgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:36:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50480 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab1LVDgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:36:42 -0500
MIME-Version: 1.0
In-Reply-To: <4EF2A410.6020400@cn.fujitsu.com>
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils>
	<20111221050740.GD23662@dastard>
	<alpine.LSU.2.00.1112202218490.4026@eggly.anvils>
	<20111221221527.GE23662@dastard>
	<alpine.LSU.2.00.1112211555430.25868@eggly.anvils>
	<4EF2A0ED.8080308@gmail.com>
	<4EF2A410.6020400@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 11:36:41 +0800
Message-ID: <CAPQyPG4h-uLhEGMGHYoBCVh-zoS7GBWDsnCQ3h6_nqAPkoE2xw@mail.gmail.com>
Subject: Re: [PATCH] radix_tree: delete orphaned macro radix_tree_indirect_to_ptr
From: Nai Xia <nai.xia@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:29 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> nai.xia wrote:
>> Seems nobody has been using the macro radix_tree_indirect_to_ptr()
>> since long time ago. Delete it.
>>
>
> Someone else has already posted the same patch.
>
> https://lkml.org/lkml/2011/12/16/118

Oh,yes!  This thread just suddenly reminds me of that long time
noop line. I should have searched recent patch submission. :)

>
>> Signed-off-by: Nai Xia <nai.xia@gmail.com>
>> ---
>>  include/linux/radix-tree.h |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> --- a/include/linux/radix-tree.h
>> +++ b/include/linux/radix-tree.h
>> @@ -49,9 +49,6 @@
>>  #define RADIX_TREE_EXCEPTIONAL_ENTRY    2
>>  #define RADIX_TREE_EXCEPTIONAL_SHIFT    2
>>
>> -#define radix_tree_indirect_to_ptr(ptr) \
>> -    radix_tree_indirect_to_ptr((void __force *)(ptr))
>> -
>>  static inline int radix_tree_is_indirect_ptr(void *ptr)
>>  {
>>      return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
