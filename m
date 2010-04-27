Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0D0NBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:01:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab0D0NBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:01:49 -0400
Message-ID: <4BD6E039.4090201@redhat.com>
Date: Tue, 27 Apr 2010 16:01:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/22] KVM: SVM: Initialize Nested Nested MMU context
 on VMRUN
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-21-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-21-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch adds code to initialize the Nested Nested Paging
> MMU context when the L1 guest executes a VMRUN instruction
> and has nested paging enabled in its VMCB.
>   				  struct kvm_mmu_page *sp,
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e31f601..266b1d4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -94,7 +94,6 @@ struct nested_state {
>
>   	/* Nested Paging related state */
>   	u64 nested_cr3;
> -
>   };
>    

Better not to introduce in the first place (I resisted commenting on it, 
but now I broke down).


-- 
error compiling committee.c: too many arguments to function

