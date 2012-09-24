Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2IXE7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:59:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57297 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab2IXE7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:59:41 -0400
Message-ID: <505FE8B4.8030309@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 12:59:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: MMU: fix release noslot pfn
References: <505C0FA8.5070007@linux.vnet.ibm.com> <505C0FCF.2070308@linux.vnet.ibm.com> <20120923091335.GA20907@redhat.com>
In-Reply-To: <20120923091335.GA20907@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092404-8256-0000-0000-0000044BA2E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 05:13 PM, Gleb Natapov wrote:
> On Fri, Sep 21, 2012 at 02:57:19PM +0800, Xiao Guangrong wrote:
>> We can not directly call kvm_release_pfn_clean to release the pfn
>> since we can meet noslot pfn which is used to cache mmio info into
>> spte
>>
> Wouldn't it be better to move the check into kvm_release_pfn_clean()?

I think there is no reason for us to prefer to adding this branch in
the common code. :)

