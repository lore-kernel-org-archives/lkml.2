Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2BBRs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:48:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2BBRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:48:27 -0500
Message-ID: <4F2ACC64.9060503@gmail.com>
Date: Fri, 03 Feb 2012 01:48:20 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: x86: move kvm_exit related definitions into
 kvm_exit.h
References: <4F2AC707.7020801@gmail.com> <4F2AC753.4020905@gmail.com> <4F2AC818.1000905@redhat.com>
In-Reply-To: <4F2AC818.1000905@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 01:30 AM, Avi Kivity wrote:

> On 02/02/2012 07:26 PM, Xiao Guangrong wrote:
>> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>
>> Move the definitions into a separate .h file so that 'perf kvm-events' can
>> easily use these
> 
> Why not just include vmx.h and svm.h?  I don't like scattering those
> definitions around.
> 


Err, if we directly include "vmx.h" and "svm.h" we should use
"#ifdef __KERNEL__" to split the definition, it is ugly i think,
but i do not have strong opinion on it, i will switch to your way :)
