Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab2IEJnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2IEJnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:43:11 -0400
Message-ID: <50471EAB.5060309@redhat.com>
Date: Wed, 05 Sep 2012 12:43:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86 emulator: use aligned variants of SSE register
 ops
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com> <1346283020-22385-3-git-send-email-minipli@googlemail.com> <5045EF86.4080600@redhat.com> <5045F06F.5030101@redhat.com> <CA+rthh8T3Y9XAz+J3C7KfeJa_0d9if9GSrhwTNYhPR+RgEnXKg@mail.gmail.com>
In-Reply-To: <CA+rthh8T3Y9XAz+J3C7KfeJa_0d9if9GSrhwTNYhPR+RgEnXKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 03:51 PM, Mathias Krause wrote:
> On Tue, Sep 4, 2012 at 2:13 PM, Avi Kivity <avi@redhat.com> wrote:
>> On 09/04/2012 03:09 PM, Avi Kivity wrote:
>>> On 08/30/2012 02:30 AM, Mathias Krause wrote:
>>>> As the the compiler ensures that the memory operand is always aligned
>>>> to a 16 byte memory location,
>>>
>>> I'm not sure it does.  Is V4SI aligned?  Do we use alignof() to
>>> propagate the alignment to the vcpu allocation code?
> 
> I checked that to by introducing a dummy char member in struct operand
> that would have misaligned vec_val but, indeed, the compiler ensured
> it's still 16 byte aligned.

Ok.

> 
>>
>> We actually do.  But please rebase the series against next, I got some
>> conflicts while applying.
> 
> If "next" means kvm/next
> (i.e.git://git.kernel.org/pub/scm/virt/kvm/kvm.git#next) here, the
> whole series applies cleanly for me.
> HEAD in kvm/next is 9a78197 "KVM: x86: remove unused variable from
> kvm_task_switch()" here. Albeit the series was build against kvm/next
> at the time as a81aba1 "KVM: VMX: Ignore segment G and D bits when
> considering whether we can virtualize" was HEAD in this branch.
> 
> Could you please retry and show me the conflicts you get?

I tried again and it applies cleanly now, so it must have been a user
error earlier.

All applied, thanks.

-- 
error compiling committee.c: too many arguments to function
