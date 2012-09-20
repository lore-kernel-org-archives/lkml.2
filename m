Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2ITDAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 23:00:00 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60462 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2ITC76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:59:58 -0400
Message-ID: <505A86A5.6090209@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2012 10:59:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and page_fault_end
References: <5052FF61.3070600@linux.vnet.ibm.com> <5052FFEA.1040607@linux.vnet.ibm.com> <20120915152512.GB3037@amt.cnet> <50582DA4.8060000@linux.vnet.ibm.com> <20120918234307.GA5062@amt.cnet>
In-Reply-To: <20120918234307.GA5062@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092002-8256-0000-0000-0000043F3B6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:43 AM, Marcelo Tosatti wrote:

>>> - error pfn / mmio pfn / invalid pfn relation
>>>
>>> Have the meaning of this bits unified in a single function/helper, see
>>> comment to patch 1 (perhaps you can further improve).
>>
>> Sorry, more detail?
> 
> Should force the reader of the code to understand error pfn / mmio pfn /
> invalid pfn in a single helper. That is, avoid using error pfn at all.

Reasonable suggestion, i will think about it more. Thank you, Marcelo!

