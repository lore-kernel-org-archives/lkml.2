Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0JTT3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:29:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:6788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0JTT3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="669250069"
Message-ID: <4CBF431C.3070002@linux.intel.com>
Date: Wed, 20 Oct 2010 12:29:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: svaidy@linux.vnet.ibm.com, Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>	 <4CBDE5AB.4040401@linux.intel.com>	 <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com>	 <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com>	 <4CBF0854.6080903@linux.intel.com> <4CBF0C04.5070705@linux.intel.com>	 <4CBF12CB.9050604@linux.intel.com>	 <20101020191941.GA706@dirshya.in.ibm.com>	 <4CBF4243.4040104@linux.intel.com> <1287602923.3673.1.camel@laptop>
In-Reply-To: <1287602923.3673.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/20/2010 12:28 PM, Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 12:25 -0700, Arjan van de Ven wrote:
>> (the pm_idle is an x86 only problem. other architectures should be able
>> to keep doing what they are doing)
> sadly no, some architectures copied this brilliant piece of design.
>
> A quick git grep suggests:
> arm/blackfin/cris/ia64/m32r/m68knommu/microblaze/mn10300/sh/sparc all
> have pm_idle.

any of those that only every use one are the easy case.

the ones that use multiple can convert to the same solution x86 has over 
time.


