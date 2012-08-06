Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2HFNEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2HFNEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:04:22 -0400
Message-ID: <501FC0B9.30006@redhat.com>
Date: Mon, 06 Aug 2012 16:03:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] KVM: introduce KVM_PFN_ERR_FAULT
References: <501B7F94.7090308@linux.vnet.ibm.com> <501B7FD2.4000305@linux.vnet.ibm.com> <501FC021.5010609@redhat.com>
In-Reply-To: <501FC021.5010609@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 04:01 PM, Avi Kivity wrote:
> On 08/03/2012 10:37 AM, Xiao Guangrong wrote:
>> After that, the exported and un-inline function, get_fault_pfn,
>> can be removed
>> 
>> 
>> +#define KVM_PFN_ERR_FAULT	(-EFAULT)
>> +
> 
> IMO this symbol isn't needed, just use -EFAULT (and -EHWPOISON etc.)
> directly.  Just document it in hva_to_pfn(), since this isn't an
> ordinary -EFAULT (and -ENOENT certainly needs describing).

Okay, I see why you did that, in patch 10.


-- 
error compiling committee.c: too many arguments to function
