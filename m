Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1KUInM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:43:12 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54621 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1KUInH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:43:07 -0500
Message-ID: <4ECA0F15.8010400@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 16:43:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC622F8.30005@linux.vnet.ibm.com> <4EC8E2D3.1080804@redhat.com> <4EC9A136.7080004@oss.ntt.co.jp> <4ECA0D00.8080708@redhat.com> <4ECA0E87.4070909@oss.ntt.co.jp>
In-Reply-To: <4ECA0E87.4070909@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112023-3568-0000-0000-000000C14A21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 04:40 PM, Takuya Yoshikawa wrote:

> (2011/11/21 17:34), Avi Kivity wrote:
>>> Do you have any preference for the arguments ordering?
>>>
>>> I think placing the target one, memslot in this case, first is
>>> conventional in
>>> the kernel code, except when we want to place "kvm" or something like
>>> that.
>>>
>>> But in kvm code, there seems to be some difference.
>>
>> You mean for the macro?  Yes, making memslot the first argument is a
>> good idea.  Any difference in kvm code is not intentional.
>>
> 
> Yes.
> 
> Xiao, please change the order if you have no problem.
> 


OK, will change it in the next version, thanks!

