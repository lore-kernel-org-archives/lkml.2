Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0ELFrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:47:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0ELFrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:47:42 -0400
Subject: Re: [PATCH 0/9] pvclock misc fixes - v4.
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4BEA21A1.8040702@redhat.com>
Date: Wed, 12 May 2010 07:47:39 +0200
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <AFD76714-2559-4281-AB61-EA5C6395C13A@suse.de>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com> <4BEA21A1.8040702@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12.05.2010, at 05:33, Zachary Amsden wrote:

> On 05/11/2010 06:17 AM, Glauber Costa wrote:
>> This is the fourth version ov kvmclock fixes.
>> 
>> Just two minor changes in patch 5, per avi request, and
>> the addition of cpuid.txt file, documenting all cpuid flags
>> we use.
>> 
>> As a side effect, this patch removes the time-travel feature
>> in kvm guests.
>> 
>> Glauber Costa (9):
>>   Enable pvclock flags in vcpu_time_info structure
>>   Add a global synchronization point for pvclock
>>   change msr numbers for kvmclock
>>   add new KVMCLOCK cpuid feature
>>   export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
>>   Try using new kvm clock msrs
>>   don't compute pvclock adjustments if we trust the tsc
>>   Tell the guest we'll warn it about tsc stability
>>   Add cpuid.txt file
>> 
>>  Documentation/kvm/cpuid.txt        |   44 ++++++++++++++++++++++++++++
>>  arch/x86/include/asm/kvm_para.h    |   13 ++++++++
>>  arch/x86/include/asm/pvclock-abi.h |    4 ++-
>>  arch/x86/include/asm/pvclock.h     |    1 +
>>  arch/x86/kernel/kvmclock.c         |   56 ++++++++++++++++++++++-------------
>>  arch/x86/kernel/pvclock.c          |   37 +++++++++++++++++++++++
>>  arch/x86/kvm/x86.c                 |   44 +++++++++++++++++++++++++++-
>>  7 files changed, 176 insertions(+), 23 deletions(-)
>>  create mode 100644 Documentation/kvm/cpuid.txt
>> 
>>   
> Acked-by: Zachary Amsden <zamsden@redhat.com>


How about stable queuing of this one?

Alex

