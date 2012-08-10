Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab2HJCME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:12:04 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59097 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2HJCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:12:00 -0400
Message-ID: <50246DD0.3050704@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2012 10:11:28 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 02/12] KVM: hide KVM_MEMSLOT_INVALID from userspace
References: <5020E423.9080004@linux.vnet.ibm.com> <5020E481.1050203@linux.vnet.ibm.com> <20120809184844.GA20889@amt.cnet>
In-Reply-To: <20120809184844.GA20889@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081002-0260-0000-0000-000001A7A418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 02:48 AM, Marcelo Tosatti wrote:

>> +#define KVM_MEMSLOT_INVALID	(1UL << 31)
>> +
>>  /*
>>   * If we support unaligned MMIO, at most one fragment will be split into two:
>>   */
> 
> Please document which range is for userspace visible flags, which range
> is reserved. Mention that in both headers, point to each other
> ("userspace definitions are there" / "internal definitions are there").
> 
> 16/16 bits for each should be fine.

Okay, good to me, will do it in the next version, thank you, Marcelo!


