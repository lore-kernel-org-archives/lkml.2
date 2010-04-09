Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0DIFCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:02:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47169 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0DIFCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=toms6jKF990YMb0GbeTCNp0XuNytff7UflSVWDihEZLAhpCVRVcxOYHd94M5FxAb7s
         le/4pdWPylu7M6e0doDEzlAufNtoYzIpcgBKema6tZIhnH1xdi1YRr7k0SHQo4eQvUy0
         h552OT6ovjHmCLQLbDIIr/R3xVcR/qYepHGl0=
Subject: Re: [PATCH 2/3] flex_array: export some symbols for
 nfnetlink_queue use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaosuo@gmail.com
Cc: Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
In-Reply-To: <4BBEA87B.4040807@gmail.com>
References: <4BBEA87B.4040807@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 07:02:12 +0200
Message-ID: <1270789332.2458.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 09 avril 2010 à 12:09 +0800, Changli Gao a écrit :
> export some symbols for nfnetlink_queue use
> 
> export some symbols for nfnetlink_queue use.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
> lib/Makefile | 4 ++--
> lib/flex_array.c | 5 +++++
> 2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index 0a6ab6f..0700e74 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o flex_array.o
> +	 is_single_threaded.o plist.o decompress.o
>  

Hmm, could you instead add a lib-$(CONFIG_FLEX_ARRAY) += flex_array.o
instead ?

And do the necessary Kconfig changes as well.

You should CC people who where involved with flex_array :

scripts/get_maintainer.pl -f lib/flex_array.c

Andrew Morton <akpm@linux-foundation.org>
David Rientjes <rientjes@google.com>
Dave Hansen <dave@linux.vnet.ibm.com>
Jonathan Corbet <corbet@lwn.net>
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks


