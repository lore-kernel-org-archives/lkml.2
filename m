Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab0DHLo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:44:29 -0400
Received: from mail-iw0-f199.google.com ([209.85.223.199]:35328 "EHLO
	mail-iw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DHLo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=euHikr4OXyJEK0vh7obL8GQSVEBSkelobz+S0X6Wy/zDpJBWmllpLCSjwTmFyFHzOR
         vLPPf4r34GlkhOF1H5WQF7+St8OkL4yLIKGuy8pnaovgdUzm+LeRC+ePZGTo6mB2a/Gp
         adH3CB+Lck3xPRmZsECUiGkLzmKG56sShiElc=
MIME-Version: 1.0
In-Reply-To: <20100326034415.GB30224@localhost.localdomain>
References: <20100326034415.GB30224@localhost.localdomain>
Date: Thu, 8 Apr 2010 19:44:25 +0800
Message-ID: <t2t628d1651004080444o35d537cft6fb420ecce509844@mail.gmail.com>
Subject: Re: [PATCH] Netfilter: Fix some coding styles and remove 
	moduleparam.h
From: wzt wzt <wzt.wzt@gmail.com>
To: kaber@trash.net
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, kaber, this patch is already based on nf-next git trees.

On Fri, Mar 26, 2010 at 11:44 AM,  <wzt.wzt@gmail.com> wrote:
> Fix some coding styles and remove moduleparam.h
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
>  net/ipv4/netfilter/nf_nat_standalone.c |    3 +--
>  net/ipv4/netfilter/nf_nat_tftp.c       |    1 -
>  net/netfilter/nf_conntrack_proto.c     |    2 --
>  3 files changed, 1 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
> index 5678e95..0b49248 100644
> --- a/net/ipv4/netfilter/nf_nat_standalone.c
> +++ b/net/ipv4/netfilter/nf_nat_standalone.c
> @@ -137,9 +137,8 @@ nf_nat_fn(unsigned int hooknum,
>                                ret = nf_nat_rule_find(skb, hooknum, in, out,
>                                                       ct);
>
> -                       if (ret != NF_ACCEPT) {
> +                       if (ret != NF_ACCEPT)
>                                return ret;
> -                       }
>                } else
>                        pr_debug("Already setup manip %s for ct %p\n",
>                                 maniptype == IP_NAT_MANIP_SRC ? "SRC" : "DST",
> diff --git a/net/ipv4/netfilter/nf_nat_tftp.c b/net/ipv4/netfilter/nf_nat_tftp.c
> index b096e81..7274a43 100644
> --- a/net/ipv4/netfilter/nf_nat_tftp.c
> +++ b/net/ipv4/netfilter/nf_nat_tftp.c
> @@ -6,7 +6,6 @@
>  */
>
>  #include <linux/module.h>
> -#include <linux/moduleparam.h>
>  #include <linux/udp.h>
>
>  #include <net/netfilter/nf_nat_helper.h>
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 1a4568b..f71cd5d 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -13,12 +13,10 @@
>  #include <linux/netfilter.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> -#include <linux/skbuff.h>
>  #include <linux/vmalloc.h>
>  #include <linux/stddef.h>
>  #include <linux/err.h>
>  #include <linux/percpu.h>
> -#include <linux/moduleparam.h>
>  #include <linux/notifier.h>
>  #include <linux/kernel.h>
>  #include <linux/netdevice.h>
> --
> 1.6.5.3
>
>
