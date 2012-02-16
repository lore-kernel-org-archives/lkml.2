Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab2BPFAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:00:19 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59788 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2BPFAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:00:16 -0500
Message-ID: <4F3C8D3F.9010105@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 12:59:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com> <4F38E091.5070504@linux.vnet.ibm.com> <4F3931D6.2090305@gmail.com>
In-Reply-To: <4F3931D6.2090305@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021604-3864-0000-0000-0000016974E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 11:52 PM, David Ahern wrote:


>> The first patch is only needed for code compilation, after kvm-events is
>> compiled, you can analyse any kernels. :)
> 
> understood.
> 
> Now that I recall perf's way of handling out of tree builds, a couple of
> comments:
> 
> 1. you need to add the following to tools/perf/MANIFEST
> arch/x86/include/asm/svm.h
> arch/x86/include/asm/vmx.h
> arch/x86/include/asm/kvm_host.h
> 


Right.

> 2.scripts/checkpatch.pl is an unhappy camper.
> 


It seems checkpath always complains about TRACE_EVENT and many more
than-80-characters lines in perf tools.

> I'll take a look at the code and try out the command when I get some time.
> 


Okay, i will post the next version after collecting your new comments!

Thanks for your time, David! :)

