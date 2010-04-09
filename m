Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0DIFJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:09:08 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:64919 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0DIFJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AlAr07I+r06V+lRkIdd5g/N4jXM9YqnccVVECfLmHq9Dl5JoI1+yNfKTpzoBJtsLWz
         d6Fe1FiWbJXLztjdTOEWhEfpnQJqEmBrhEZjYyJh+gbDpL3eM+ah7d7kBoc0HQGh1+wo
         08pMy9TDrw7hGN6cgT6LNuiPHg4q/G2sm7PQw=
MIME-Version: 1.0
In-Reply-To: <1270789332.2458.23.camel@edumazet-laptop>
References: <4BBEA87B.4040807@gmail.com>
	 <1270789332.2458.23.camel@edumazet-laptop>
Date: Fri, 9 Apr 2010 13:09:03 +0800
Message-ID: <l2x2375c9f91004082209p9b13a651zc227448380f65b16@mail.gmail.com>
Subject: Re: [PATCH 2/3] flex_array: export some symbols for nfnetlink_queue 
	use
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: xiaosuo@gmail.com, Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 1:02 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 09 avril 2010 à 12:09 +0800, Changli Gao a écrit :
>> export some symbols for nfnetlink_queue use
>>
>> export some symbols for nfnetlink_queue use.
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ----
>> lib/Makefile | 4 ++--
>> lib/flex_array.c | 5 +++++
>> 2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/Makefile b/lib/Makefile
>> index 0a6ab6f..0700e74 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>>        idr.o int_sqrt.o extable.o prio_tree.o \
>>        sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>>        proportions.o prio_heap.o ratelimit.o show_mem.o \
>> -      is_single_threaded.o plist.o decompress.o flex_array.o
>> +      is_single_threaded.o plist.o decompress.o
>>
>
> Hmm, could you instead add a lib-$(CONFIG_FLEX_ARRAY) += flex_array.o
> instead ?
>
> And do the necessary Kconfig changes as well.
>

Right, if nfnetlink will use flex_array, CONFIG_NETFILTER_NETLINK will
need to depend on or select CONFIG_FLEX_ARRAY.
