Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2C1Sdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:33:41 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57821 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab2C1Sdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:33:39 -0400
Message-ID: <4F73593D.5020305@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 00:02:29 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 <x86@kernel.org>,
        Avi Kivity <avi@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 0/6] kvm : Paravirt-spinlock support for KVM guests
References: <20120323080503.14568.43092.sendpatchset@codeblue>
In-Reply-To: <20120323080503.14568.43092.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032808-1618-0000-0000-0000012D12CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 01:35 PM, Raghavendra K T wrote:
> The 6-patch series to follow this email extends KVM-hypervisor and Linux guest
> running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's
> implementation.
>
> One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
> another vcpu out of halt state.
> The blocking of vcpu is done using halt() in (lock_spinning) slowpath.
> one MSR is added to aid live migration.
>
> Changes in V5:
> - rebased to 3.3-rc6
> - added PV_UNHALT_MSR that would help in live migration (Avi)
> - removed PV_LOCK_KICK vcpu request and pv_unhalt flag (re)added.

Sorry for pinging
I know it is busy time. But I hope to get response on these patches in 
your free time, so that I can target next merge window for this. 
(whether it has reached some good state or it is heading in reverse 
direction!). it would really boost my morale.
especially MSR stuff and dropping vcpu request bit for PV unhalt.

- Raghu

