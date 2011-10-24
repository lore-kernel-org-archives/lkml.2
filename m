Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1JXJaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:30:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:40726 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1JXJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:30:21 -0400
Message-ID: <4EA53044.2020902@linux.vnet.ibm.com>
Date: Mon, 24 Oct 2011 15:00:44 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 1/5] debugfs: Add support to print u32 array in
 debugfs
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190403.16364.30897.sendpatchset@oc5400248562.ibm.com> <20111023222012.GB591@suse.de>
In-Reply-To: <20111023222012.GB591@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 03:50 AM, Greg KH wrote:
> On Mon, Oct 24, 2011 at 12:34:04AM +0530, Raghavendra K T wrote:
>> Add debugfs support to print u32-arrays in debugfs. Move the code from Xen to debugfs
>> to make the code common for other users as well.
>
> You forgot the kerneldoc for the function explaining what it is and how
> to use it, and the EXPORT_SYMBOL_GPL() marking for the global function
> as that's the only way it will be able to be used, right?
>
Greg right. Thanks for finding this. I 'll update the patch for that.
> thanks,
>
> greg k-h
>

