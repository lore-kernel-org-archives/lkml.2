Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2D3IT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab2D3ITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:19:55 -0400
Message-ID: <4F9E4B17.7060909@redhat.com>
Date: Mon, 30 Apr 2012 11:19:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V6 1/5] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423095947.30893.84029.sendpatchset@codeblue.in.ibm.com> <4F9D415B.7010103@redhat.com> <4F9E42F6.8050108@linux.vnet.ibm.com>
In-Reply-To: <4F9E42F6.8050108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 10:44 AM, Raghavendra K T wrote:
>> Hm, what about reusing KVM_REQ_UNHALT?
>>
>
>
> Yes, I had experimented this for some time without success.
> For e.g. having
> make_request(KVM_REQ_UNHALT, vcpu) directly from kick hypercall.
>
> It would still need a flag. (did not get any alternative so far except
> the  workaround posted in V4) :(
>

Okay.

-- 
error compiling committee.c: too many arguments to function

