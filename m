Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1KUIj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:39:56 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:46534 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1KUIjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:39:55 -0500
Message-ID: <4ECA0E87.4070909@oss.ntt.co.jp>
Date: Mon, 21 Nov 2011 17:40:39 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC622F8.30005@linux.vnet.ibm.com> <4EC8E2D3.1080804@redhat.com> <4EC9A136.7080004@oss.ntt.co.jp> <4ECA0D00.8080708@redhat.com>
In-Reply-To: <4ECA0D00.8080708@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/21 17:34), Avi Kivity wrote:
>> Do you have any preference for the arguments ordering?
>>
>> I think placing the target one, memslot in this case, first is
>> conventional in
>> the kernel code, except when we want to place "kvm" or something like
>> that.
>>
>> But in kvm code, there seems to be some difference.
>
> You mean for the macro?  Yes, making memslot the first argument is a
> good idea.  Any difference in kvm code is not intentional.
>

Yes.

Xiao, please change the order if you have no problem.

Thanks,
	Takuya
