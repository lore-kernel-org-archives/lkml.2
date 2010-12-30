Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0L3CTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 21:19:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55279 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0L3CTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 21:19:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mw5iJ+SFhk2R4cICbcd3gymG8mkqrSAas8Kn20RKzoJ6U5yDe7EqFYUCXel10SIQmX
         Rybzfz2OQMwuJXLZqdnXTA/nzpgtCCIUpKE/jPUwZEsmFIDkV1qK/zZrhP88ZFQZq3xu
         TbmSdmJxC7DNIEv8Ya7gZu1N9yRQgrm4K+XWk=
MIME-Version: 1.0
In-Reply-To: <20101229085300.1ceac200.randy.dunlap@oracle.com>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au> <20101229085300.1ceac200.randy.dunlap@oracle.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 30 Dec 2010 10:18:43 +0800
Message-ID: <AANLkTin8Zc4wkx9BjD0vJSNdne8LVHx=JyeSC2YdKTKH@mail.gmail.com>
Subject: Re: linux-next: Tree for December 29 (netfilter build errors)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netfilter-devel@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 12:53 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 29 Dec 2010 13:07:00 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20101228:
>
>
> In file included from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:22:
> linux-next-20101229/include/net/netfilter/nf_conntrack.h:94: error: field 'ct_general' has incomplete type
> linux-next-20101229/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
> linux-next-20101229/include/net/netfilter/nf_conntrack.h:174: error: 'const struct sk_buff' has no member named 'nfct'
> linux-next-20101229/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
> linux-next-20101229/include/net/netfilter/nf_conntrack.h:181: error: implicit declaration of function 'nf_conntrack_put'
>  CC      net/ipv6/exthdrs_core.o
> In file included from linux-next-20101229/include/net/netfilter/nf_conntrack_core.h:18,
>                 from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:26:
> linux-next-20101229/include/net/netfilter/nf_conntrack_ecache.h: In function 'nf_ct_ecache_ext_add':
> linux-next-20101229/include/net/netfilter/nf_conntrack_ecache.h:35: error: 'struct net' has no member named 'ct'
> In file included from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:26:
> linux-next-20101229/include/net/netfilter/nf_conntrack_core.h: In function 'nf_conntrack_confirm':
> linux-next-20101229/include/net/netfilter/nf_conntrack_core.h:60: error: 'struct sk_buff' has no member named 'nfct'
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'nf_ct6_defrag_user':
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:36: error: 'struct sk_buff' has no member named 'nfct'
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: implicit declaration of function 'nf_ct_zone'
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: 'struct sk_buff' has no member named 'nfct'
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'ipv6_defrag':
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
> make[4]: *** [net/ipv6/netfilter/nf_defrag_ipv6_hooks.o] Error 1
> make[3]: *** [net/ipv6/netfilter] Error 2
>
>
>

This bug has been already fixed in nf-next-2.6:
http://git.kernel.org/?p=linux/kernel/git/kaber/nf-next-2.6.git;a=commitdiff;h=ae90bdeaeac6b964b7a1e853a90a19f358a9ac20;hp=f1c722295e029eace7960fc687efd5afd67dc555

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
