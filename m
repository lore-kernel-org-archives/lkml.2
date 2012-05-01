Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2EANFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:05:15 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46169 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2EANFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:05:14 -0400
Message-ID: <4F9FDF69.8090101@linux.vnet.ibm.com>
Date: Tue, 01 May 2012 18:34:41 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Jones <drjones@redhat.com>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Xen-devel] [PATCH RFC V7 0/12] Paravirtualized ticketlocks
References: <20120419201209.5411.43877.sendpatchset@codeblue> <1335876646.6038.101.camel@zakaz.uk.xensource.com>
In-Reply-To: <1335876646.6038.101.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050102-0260-0000-0000-000000F77D44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 06:20 PM, Ian Campbell wrote:
> On Thu, 2012-04-19 at 21:12 +0100, Raghavendra K T wrote:
>> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>>
>> This series replaces the existing paravirtualized spinlock mechanism
>> with a paravirtualized ticketlock mechanism. (targeted for 3.5 window)
>
> Which tree is this series going through, tip.git I guess?
>
> I don't see it there.
>
> Ian.
>

Yes you are right.

I am trying to post ticketlock + xen + kvm patches series in one
go. There are some discussions on kvm patches last few days. So I am
putting up all of them together now.  I am planning to post within 
half/one day.

