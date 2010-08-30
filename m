Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0H3K4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab0H3K4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:56:38 -0400
Message-ID: <4C7B8E5F.6090106@redhat.com>
Date: Mon, 30 Aug 2010 13:56:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kvm tree
References: <20100830113523.28e6fa9e.sfr@canb.auug.org.au> <0568D973-31CA-4E44-8583-D39A58FCEDD8@suse.de>
In-Reply-To: <0568D973-31CA-4E44-8583-D39A58FCEDD8@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/30/2010 01:03 PM, Alexander Graf wrote:
> On 30.08.2010, at 03:35, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> After merging the kvm tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>>
>> arch/powerpc/kernel/asm-offsets.c: In function 'main':
>> arch/powerpc/kernel/asm-offsets.c:470: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>> arch/powerpc/kernel/asm-offsets.c:472: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>> arch/powerpc/kernel/asm-offsets.c:474: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>> arch/powerpc/kernel/asm-offsets.c:476: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>> arch/powerpc/kernel/asm-offsets.c:478: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>> arch/powerpc/kernel/asm-offsets.c:479: error: invalid use of undefined type 'struct kvm_vcpu_arch_shared'
>>
>> Caused by commits 3623fdb1aa54678f73da95e797eb6e4756d4bd0e ("KVM: PPC:
>> Convert MSR to shared page") and 158a244474a6620715c626d4647fec4d61aaeee7
>> ("KVM: PPC: Generic KVM PV guest support").
>>
>> I have used the kvm tree from next-20100827 for today.
> I sent a fix out to the ML. Avi or Marcelo, could you please merge that one in quickly? The !CONFIG_KVM but CONFIG_KVM_GUEST case was the one combination I didn't try out :(.
>

Done, next linux-next should have the fix.

-- 
error compiling committee.c: too many arguments to function

