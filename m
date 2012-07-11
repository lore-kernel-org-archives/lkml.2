Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab2GKSgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab2GKSgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:36:53 -0400
Message-ID: <4FFDAB10.8020404@redhat.com>
Date: Wed, 11 Jul 2012 19:34:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform
 check [v2]
References: <1341493877-16622-1-git-send-email-prarit@redhat.com> <1341493877-16622-2-git-send-email-prarit@redhat.com> <4FF59606.4060504@redhat.com> <4FF5987C.6080905@redhat.com> <20120706112719.GA18059@amt.cnet> <4FF724BB.5040008@redhat.com>
In-Reply-To: <4FF724BB.5040008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 08:47 PM, Prarit Bhargava wrote:
> [PATCH 1/2] kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform check [v3]
> 
> While debugging I noticed that unlike all the other hypervisor code in the
> kernel, kvm does not have an entry for x86_hyper which is used in
> detect_hypervisor_platform() which results in a nice printk in the
> syslog.  This is only really a stub function but it
> does make kvm more consistent with the other hypervisors.

Thanks, applied.

> 
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -37,6 +37,7 @@ static const __initconst struct hypervisor_x86 * const
> hypervisors[] =

Corrupted patch, fixed by hand.

>  #endif

-- 
error compiling committee.c: too many arguments to function


