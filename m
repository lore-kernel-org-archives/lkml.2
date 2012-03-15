Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031935Ab2COQwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:52:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50555 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031783Ab2COQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:52:32 -0400
Date: Thu, 15 Mar 2012 12:48:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 0/2] kvm: Transcendent Memory (tmem) on KVM
Message-ID: <20120315164828.GK30250@phenom.dumpdata.com>
References: <1331224181.2585.16.camel@aks>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331224181.2585.16.camel@aks>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F621E4F.0027,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> kvm-tmem Patch details:
> This patch adds appropriate shims at the guest that invokes the kvm
> hypercalls, and the host uses zcache pools to implement the required
> functions.
> 
> To enable tmem on the 'kvm host' add the boot parameter:
> "kvmtmem"
> And to enable tmem in the 'kvm guests' add the boot parameter:
> "tmem"
> 
> The diffstat details for this patch are given below:
>  arch/x86/include/asm/kvm_host.h      |    1 
>  arch/x86/kvm/x86.c                   |    4 
>  drivers/staging/zcache/Makefile      |    2 
>  drivers/staging/zcache/kvm-tmem.c    |  356 +++++++++++++++++++++++++++++++++++
>  drivers/staging/zcache/kvm-tmem.h    |   55 +++++
>  drivers/staging/zcache/zcache-main.c |   98 ++++++++-
>  include/linux/kvm_para.h             |    1 
>  7 files changed, 508 insertions(+), 9 deletions(-)
> 	
> We have already uploaded our work alongwith the 'Frontswap' submitted by Dan,
> on the following link:
> https://github.com/akshaykarle/kvm-tmem

Is there a way for these patches to be posted on LKML? It is rather difficult
to copy-n-paste patches in emails and sending them. Or if you want to, you can
email them directly to me. To do that use 'git send-email' and 'git format-patch'
to prep the git commits into patches.


Also, the title says 'RFC 0/2' but I am not seing 1 or 2?
