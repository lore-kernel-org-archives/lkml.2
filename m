Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2INGAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:00:08 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46183 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2INGAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:00:04 -0400
Message-ID: <5052C7DD.4000205@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 13:59:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: trace the events of mmu_notifier
References: <50499123.70609@linux.vnet.ibm.com> <504DAE34.1060402@redhat.com> <504DB22F.4020609@linux.vnet.ibm.com>
In-Reply-To: <504DB22F.4020609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091405-9264-0000-0000-000002548B13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:26 PM, Xiao Guangrong wrote:
> On 09/10/2012 05:09 PM, Avi Kivity wrote:
>> On 09/07/2012 09:16 AM, Xiao Guangrong wrote:
>>> mmu_notifier is the interface to broadcast the mm events to KVM, the
>>> tracepoints introduced in this patch can trace all these events, it is
>>> very helpful for us to notice and fix the bug caused by mm
>>
>> There is nothing kvm specific here.  Perhaps this can be made generic
>> (with a mm parameter so we can filter by process).
> 
> Hmm, i would like to put these tracepoints in the mmu-lock then we can clearly
> know the sequence between mm and kvm mmu. It is useful for us to detect the
> issue/race between them.
> 

Ping...?

