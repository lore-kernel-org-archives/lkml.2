Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2I1Or2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:47:28 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:59709 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab2I1OrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:47:25 -0400
Message-ID: <5065B84F.6060204@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 20:16:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Conny Seidel <conny.seidel@amd.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] CPU hotplug, writeback: Don't call writeback_set_ratelimit()
 too often during hotplug
References: <20120924102324.GA22303@aftab.osrc.amd.com> <20120924142305.GD12264@quack.suse.cz> <20120924143609.GH22303@aftab.osrc.amd.com> <20120924201650.6574af64.conny.seidel@amd.com> <20120924181927.GA25762@aftab.osrc.amd.com> <5060AB0E.3070809@linux.vnet.ibm.com> <5060C714.8030606@linux.vnet.ibm.com> <20120928122719.GA3067@localhost>
In-Reply-To: <20120928122719.GA3067@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092814-9264-0000-0000-0000026A2673
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 05:57 PM, Fengguang Wu wrote:
> On Tue, Sep 25, 2012 at 02:18:20AM +0530, Srivatsa S. Bhat wrote:
>>
>> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>
>> The CPU hotplug callback related to writeback calls writeback_set_ratelimit()
>> during every state change in the hotplug sequence. This is unnecessary
>> since num_online_cpus() changes only once during the entire hotplug operation.
>>
>> So invoke the function only once per hotplug, thereby avoiding the
>> unnecessary repetition of those costly calculations.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
> 
> Looks good to me. I'll include it in the writeback tree.
> 

Great, thanks!
 
Regards,
Srivatsa S. Bhat

