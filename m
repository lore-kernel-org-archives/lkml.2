Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab2BMPxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:53:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54657 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2BMPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:52:59 -0500
Message-ID: <4F3931D6.2090305@gmail.com>
Date: Mon, 13 Feb 2012 08:52:54 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
References: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com> <4F38E091.5070504@linux.vnet.ibm.com>
In-Reply-To: <4F38E091.5070504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/13/2012 03:06 AM, Xiao Guangrong wrote:
> On 02/13/2012 01:32 PM, David Ahern wrote:
> 
>> [sorry for the top post - you would think Android would have a better mail client]
>>
>> If the first patch is needed then kvm-events will not work with older, unpatched kernels. That's a big limitation from a perf perpective.
>>
> 
> 
> The first patch is only needed for code compilation, after kvm-events is
> compiled, you can analyse any kernels. :)

understood.

Now that I recall perf's way of handling out of tree builds, a couple of
comments:

1. you need to add the following to tools/perf/MANIFEST
arch/x86/include/asm/svm.h
arch/x86/include/asm/vmx.h
arch/x86/include/asm/kvm_host.h

2.scripts/checkpatch.pl is an unhappy camper.

I'll take a look at the code and try out the command when I get some time.

David
