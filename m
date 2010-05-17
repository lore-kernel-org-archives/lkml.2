Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0EQJTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0EQJTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:19:18 -0400
Message-ID: <4BF10A06.5040902@redhat.com>
Date: Mon, 17 May 2010 12:19:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2 1/3] x86: Export FPU API for KVM use
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com> <1274087308-26676-2-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1274087308-26676-2-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 12:08 PM, Sheng Yang wrote:
> Also add some constants.
>    

> +++ b/arch/x86/kernel/process.c
> @@ -28,6 +28,7 @@ unsigned long idle_nomwait;
>   EXPORT_SYMBOL(idle_nomwait);
>
>   struct kmem_cache *task_xstate_cachep;
> +EXPORT_SYMBOL(task_xstate_cachep);
>
>   int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>   {
>    

_GPL() unless good reason not to.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

