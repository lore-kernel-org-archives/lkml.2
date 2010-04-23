Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0DWN7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab0DWN7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:59:32 -0400
Message-ID: <4BD1A7BB.20206@redhat.com>
Date: Fri, 23 Apr 2010 16:59:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 5/8] KVM: X86: Add callback to let modules decide over
 some supported cpuid bits
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-6-git-send-email-joerg.roedel@amd.com> <8750FE80-57D8-4D59-AC4A-D04B04E8707B@suse.de>
In-Reply-To: <8750FE80-57D8-4D59-AC4A-D04B04E8707B@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 04:52 PM, Alexander Graf wrote:
> On 22.04.2010, at 12:33, Joerg Roedel wrote:
>
>    
>> This patch adds the get_supported_cpuid callback to
>> kvm_x86_ops. It will be used in do_cpuid_ent to delegate the
>> decission about some supported cpuid bits to the
>> architecture modules.
>>
>> Cc: stable@kernel.org
>>      
> Please don't CC stable. There is a KVM stable tag now, so every stable submission goes through Avi/Marcelo.
>
>
>    

It's not a problem.  stable@ will ignore kvm patches not coming from the 
maintainers, and we will recognize cc: stable as a stable request.

(the new approach is to collect the patches in kvm-updates/2.6.x, 
autotest, and forward to stable@).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

