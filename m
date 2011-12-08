Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1LHCA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 21:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1LHCA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 21:00:26 -0500
Message-ID: <4EE01ABC.4060405@redhat.com>
Date: Thu, 08 Dec 2011 10:02:36 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Wang YanQing <Udknight@gmail.com>, trivial <trivial@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][TRIVIAL] mainline: Fix typo: change aera to area in "*.[ch]"
References: <20111208014739.GA6934@udknight.homenetwork>
In-Reply-To: <20111208014739.GA6934@udknight.homenetwork>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 09:47 AM, Wang YanQing wrote:

> The shell command below make this patch:
> find . -name "*.[ch]" | xargs grep -l -w "aera" | xargs sed -i s/aera/area/g
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  arch/x86/pci/pcbios.c            |    2 +-
>  net/ipv4/netfilter/nf_nat_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
> index db0e9a5..da8fe05 100644
> --- a/arch/x86/pci/pcbios.c
> +++ b/arch/x86/pci/pcbios.c
> @@ -44,7 +44,7 @@ static inline void set_bios_x(void)
>  	pcibios_enabled = 1;
>  	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
>  	if (__supported_pte_mask & _PAGE_NX)
> -		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
> +		printk(KERN_INFO "PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.\n");
>  }
>  
>  /*
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
> index 447bc5c..12a8b74 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -318,7 +318,7 @@ nf_nat_setup_info(struct nf_conn *ct,
>  		srchash = hash_by_src(net, nf_ct_zone(ct),
>  				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>  		spin_lock_bh(&nf_nat_lock);
> -		/* nf_conntrack_alter_reply might re-allocate exntension aera */
> +		/* nf_conntrack_alter_reply might re-allocate exntension area */


s/exntension/extension ?

>  		nat = nfct_nat(ct);
>  		nat->ct = ct;
>  		hlist_add_head_rcu(&nat->bysource,



-- 
Thanks
Dave
