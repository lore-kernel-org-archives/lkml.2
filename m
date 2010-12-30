Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0L3Qrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 11:47:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49818 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab0L3Qr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 11:47:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=AIP1iKt9YvusoXePpawH2B9mdnoThT/iCVO/o0r9aV9cGNTK6hvtWXb55Z0Sji2/PD
         lnOn3junh5HJgkuZcn4Qg/201NoEvI2Ng+SF8h34mD7D1jWiobQ+YSi34qkitmBd0Q2N
         hDzsGI8aZ6mD9uXLHpa2suw502+qBbaZVVhfs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTin8Zc4wkx9BjD0vJSNdne8LVHx=JyeSC2YdKTKH@mail.gmail.com>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
	<20101229085300.1ceac200.randy.dunlap@oracle.com>
	<AANLkTin8Zc4wkx9BjD0vJSNdne8LVHx=JyeSC2YdKTKH@mail.gmail.com>
Date: Thu, 30 Dec 2010 17:47:26 +0100
Message-ID: <AANLkTikPbKOQseJ8qfoSqv4XWgH5fjbg488jd6_Xv22E@mail.gmail.com>
Subject: Re: linux-next: Tree for December 29 (netfilter build errors)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netfilter-devel@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 3:18 AM, Changli Gao <xiaosuo@gmail.com> wrote:
> On Thu, Dec 30, 2010 at 12:53 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Wed, 29 Dec 2010 13:07:00 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101228:
>>
>>
>> In file included from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:22:
>> linux-next-20101229/include/net/netfilter/nf_conntrack.h:94: error: field 'ct_general' has incomplete type
>> linux-next-20101229/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>> linux-next-20101229/include/net/netfilter/nf_conntrack.h:174: error: 'const struct sk_buff' has no member named 'nfct'
>> linux-next-20101229/include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
>> linux-next-20101229/include/net/netfilter/nf_conntrack.h:181: error: implicit declaration of function 'nf_conntrack_put'
>>  CC      net/ipv6/exthdrs_core.o
>> In file included from linux-next-20101229/include/net/netfilter/nf_conntrack_core.h:18,
>>                 from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:26:
>> linux-next-20101229/include/net/netfilter/nf_conntrack_ecache.h: In function 'nf_ct_ecache_ext_add':
>> linux-next-20101229/include/net/netfilter/nf_conntrack_ecache.h:35: error: 'struct net' has no member named 'ct'
>> In file included from linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:26:
>> linux-next-20101229/include/net/netfilter/nf_conntrack_core.h: In function 'nf_conntrack_confirm':
>> linux-next-20101229/include/net/netfilter/nf_conntrack_core.h:60: error: 'struct sk_buff' has no member named 'nfct'
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'nf_ct6_defrag_user':
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:36: error: 'struct sk_buff' has no member named 'nfct'
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: implicit declaration of function 'nf_ct_zone'
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:37: error: 'struct sk_buff' has no member named 'nfct'
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c: In function 'ipv6_defrag':
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
>> linux-next-20101229/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c:60: error: 'struct sk_buff' has no member named 'nfct'
>> make[4]: *** [net/ipv6/netfilter/nf_defrag_ipv6_hooks.o] Error 1
>> make[3]: *** [net/ipv6/netfilter] Error 2
>>
>>
>>
>
> This bug has been already fixed in nf-next-2.6:
> http://git.kernel.org/?p=linux/kernel/git/kaber/nf-next-2.6.git;a=commitdiff;h=ae90bdeaeac6b964b7a1e853a90a19f358a9ac20;hp=f1c722295e029eace7960fc687efd5afd67dc555
>
> Thanks.
>
> --
> Regards,
> Changli Gao(xiaosuo@gmail.com)
>

Does not look like the nf-next-2.6 is triggered by linux-next... Does
this tree passes net-next-2.6 and then enters linux-next?

- Sedat -

P.S.:

sd@tbox:/mnt/sdb5/linux-kernel/linux-next$ git pull
git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
master:nf-next-2.6
remote: Counting objects: 705, done.
remote: Compressing objects: 100% (415/415), done.
remote: Total 545 (delta 475), reused 149 (delta 130)
Receiving objects: 100% (545/545), 88.80 KiB | 47 KiB/s, done.
Resolving deltas: 100% (475/475), completed with 136 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6
 * [new branch]      master     -> nf-next-2.6
warning: too many files (created: 931 deleted: 428), skipping inexact
rename detection
Auto-merging include/linux/netfilter.h
Auto-merging include/linux/skbuff.h
Auto-merging net/core/skbuff.c
Auto-merging net/ipv6/netfilter/nf_conntrack_reasm.c
Auto-merging net/netfilter/core.c
Auto-merging net/netfilter/ipvs/ip_vs_ctl.c
Auto-merging net/netfilter/ipvs/ip_vs_xmit.c
Merge made by recursive.
 include/linux/ip_vs.h                              |    8 +
 include/linux/netfilter.h                          |    6 +-
 include/linux/netfilter/xt_CT.h                    |   10 +-
 include/linux/netfilter/xt_TCPOPTSTRIP.h           |    2 +-
 include/linux/netfilter/xt_TPROXY.h                |    8 +-
 include/linux/netfilter/xt_cluster.h               |    8 +-
 include/linux/netfilter/xt_quota.h                 |    6 +-
 include/linux/netfilter/xt_time.h                  |   14 +-
 include/linux/netfilter/xt_u32.h                   |   16 +-
 include/linux/skbuff.h                             |   15 +
 include/net/ip_vs.h                                |   25 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h     |   10 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |   10 +
 include/net/netfilter/nf_conntrack.h               |   19 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   12 +-
 include/net/netfilter/nf_conntrack_extend.h        |    6 +
 include/net/netfilter/nf_conntrack_l3proto.h       |    2 +-
 include/net/netfilter/nf_nat.h                     |    6 +
 include/net/netfilter/nf_nat_core.h                |    4 +-
 net/core/skbuff.c                                  |    2 +
 net/ipv4/netfilter/ipt_LOG.c                       |    3 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   17 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    8 +-
 net/ipv4/netfilter/nf_nat_core.c                   |    9 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |    3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |    8 +-
 net/netfilter/core.c                               |    4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   36 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   94 ++-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   36 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |    5 +-
 net/netfilter/ipvs/ip_vs_pe.c                      |   17 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |    3 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   11 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   10 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   10 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  962 +++++++++++++++++---
 net/netfilter/ipvs/ip_vs_xmit.c                    |   26 +-
 net/netfilter/nf_conntrack_core.c                  |    3 +-
 net/netfilter/nf_conntrack_expect.c                |   25 +-
 net/netfilter/nf_conntrack_extend.c                |   11 +-
 net/netfilter/nf_conntrack_helper.c                |   10 +-
 net/netfilter/nf_conntrack_netlink.c               |    1 +
 net/netfilter/nf_conntrack_proto.c                 |   24 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |    3 +
 net/netfilter/nf_conntrack_proto_sctp.c            |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c             |   14 +-
 net/netfilter/nf_conntrack_standalone.c            |    9 +-
 net/netfilter/nf_log.c                             |    6 +-
 net/netfilter/nf_queue.c                           |   18 +-
 net/netfilter/nfnetlink_log.c                      |    6 +-
 net/netfilter/xt_CLASSIFY.c                        |   36 +-
 net/netfilter/xt_NFQUEUE.c                         |    6 +-
 54 files changed, 1258 insertions(+), 368 deletions(-)
sd@tbox:/mnt/sdb5/linux-kernel/linux-next$
