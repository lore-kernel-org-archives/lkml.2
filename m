Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1KRJ5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:57:09 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41058 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1KRJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:57:07 -0500
Message-ID: <4EC62BEA.9040007@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:56:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] KVM: optimize memslots searching
References: <4EC6226B.3080408@linux.vnet.ibm.com> <1321609310.8010.28.camel@lappy>
In-Reply-To: <1321609310.8010.28.camel@lappy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111723-0260-0000-0000-0000000ED34D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 05:41 PM, Sasha Levin wrote:


>> autotest for RHEL.6.1 setup/boot/reboot/shutdown(average):
>> ept=1:	before: 449.5	after: 447.8
>> ept=0:	before: 532.7	after: 529.8
>>
>> kernbench(average):
>> ept=1:	before: 127.94	after: 126.98
>> ept=0:	before: 196.85	after: 189.66
> 
> Hi,
> 
> Do these patches depend on any other patches? Looks like they don't
> apply on kvm-next.
> 


Ah, i forgot that i was using Avi's kvm tree, this patchset is just base
on that, to avoid noise, i'll rebase it after it is reviewed.

Thank you, Sasha!

