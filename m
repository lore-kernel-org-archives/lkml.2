Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2DAN5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:57:16 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60118 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2DAN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:57:14 -0400
Message-ID: <4F785E89.8080609@linux.vnet.ibm.com>
Date: Sun, 01 Apr 2012 19:26:25 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alan Meadows <alan.meadows@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com> <4F74A405.2040609@linux.vnet.ibm.com> <4F7585EE.7060203@linux.vnet.ibm.com> <4F7855A1.80107@redhat.com> <4F785CC9.7070204@linux.vnet.ibm.com> <4F785DCF.7020809@redhat.com>
In-Reply-To: <4F785DCF.7020809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12040113-2674-0000-0000-000003E7A522
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 07:23 PM, Avi Kivity wrote:
> On 04/01/2012 04:48 PM, Raghavendra K T wrote:
>>>> I have patch something like below in mind to try:
>
> I'm interested in how PLE does vs. your patches, both with PLE enabled
> and disabled.
>

Sure. will update with the experimental results.

