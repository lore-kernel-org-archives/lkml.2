Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2IJJ0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:26:21 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36858 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2IJJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:26:17 -0400
Message-ID: <504DB22F.4020609@linux.vnet.ibm.com>
Date: Mon, 10 Sep 2012 17:26:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: trace the events of mmu_notifier
References: <50499123.70609@linux.vnet.ibm.com> <504DAE34.1060402@redhat.com>
In-Reply-To: <504DAE34.1060402@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091009-5564-0000-0000-00000465E1CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 05:09 PM, Avi Kivity wrote:
> On 09/07/2012 09:16 AM, Xiao Guangrong wrote:
>> mmu_notifier is the interface to broadcast the mm events to KVM, the
>> tracepoints introduced in this patch can trace all these events, it is
>> very helpful for us to notice and fix the bug caused by mm
> 
> There is nothing kvm specific here.  Perhaps this can be made generic
> (with a mm parameter so we can filter by process).

Hmm, i would like to put these tracepoints in the mmu-lock then we can clearly
know the sequence between mm and kvm mmu. It is useful for us to detect the
issue/race between them.

