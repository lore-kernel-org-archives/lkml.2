Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1JXSpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:45:12 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38533 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1JXSpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:45:09 -0400
Message-ID: <4EA5B241.5040003@linux.vnet.ibm.com>
Date: Tue, 25 Oct 2011 00:15:21 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, KVM <kvm@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 4/5] kvm guest : Added configuration support to
 enable debug information for KVM Guests
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190700.16364.7548.sendpatchset@oc5400248562.ibm.com> <1319450505.5660.5.camel@lappy>
In-Reply-To: <1319450505.5660.5.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:31 PM, Sasha Levin wrote:
> On Mon, 2011-10-24 at 00:37 +0530, Raghavendra K T wrote:
>> Added configuration support to enable debug information
>> for KVM Guests in debugfs
>> +config KVM_DEBUG_FS
>> +	bool "Enable debug information for KVM Guests in debugfs"
>> +	depends on KVM_GUEST
>
> Shouldn't it depend on DEBUG_FS as well?
Thanks again for pointing. will correct this too.
