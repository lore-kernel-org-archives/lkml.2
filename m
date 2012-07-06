Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab2GFKZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:25:55 -0400
Received: from goliath.siemens.de ([192.35.17.28]:16529 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2GFKZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:25:54 -0400
Message-ID: <4FF6BD1D.8020605@siemens.com>
Date: Fri, 06 Jul 2012 12:25:33 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/7 v6] update linux headers
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B232.4050502@cn.fujitsu.com>
In-Reply-To: <4FF6B232.4050502@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-06 11:38, Wen Congyang wrote:
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Which kvm.git hash is this referring? Please state this to avoid that we
are merging support for kernel features that are still under review.

Jan

> ---
>  linux-headers/asm-x86/kvm_para.h |    2 ++
>  linux-headers/linux/kvm_para.h   |    6 ++++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/linux-headers/asm-x86/kvm_para.h b/linux-headers/asm-x86/kvm_para.h
> index f2ac46a..f9d858f 100644
> --- a/linux-headers/asm-x86/kvm_para.h
> +++ b/linux-headers/asm-x86/kvm_para.h
> @@ -89,5 +89,7 @@ struct kvm_vcpu_pv_apf_data {
>  	__u32 enabled;
>  };
>  
> +#define KVM_PV_PORT	(0x505UL)
> +
>  
>  #endif /* _ASM_X86_KVM_PARA_H */
> diff --git a/linux-headers/linux/kvm_para.h b/linux-headers/linux/kvm_para.h
> index 7bdcf93..4fbd625 100644
> --- a/linux-headers/linux/kvm_para.h
> +++ b/linux-headers/linux/kvm_para.h
> @@ -20,6 +20,12 @@
>  #define KVM_HC_FEATURES			3
>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>  
> +/* The bit of the value read from KVM_PV_PORT */
> +#define KVM_PV_FEATURE_PANICKED	0
> +
> +/* The value writen to KVM_PV_PORT */
> +#define KVM_PV_PANICKED		1
> +
>  /*
>   * hypercalls use architecture specific
>   */
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


