Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2FLUjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:39:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:13078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab2FLUju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:39:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="156766718"
Message-ID: <4FD7A915.6020606@linux.intel.com>
Date: Tue, 12 Jun 2012 13:39:49 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally
References: <1339533234-2265-1-git-send-email-andi@firstfloor.org> <4FD7A85D.4000106@zytor.com>
In-Reply-To: <4FD7A85D.4000106@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2012 1:36 PM, H. Peter Anvin wrote:
> On 06/12/2012 01:33 PM, Andi Kleen wrote:
>>
>> +/* Global minimum microcode version */
>> +int min_microcode;
>> +
> Any reason not to use boot_cpu_data.microcode for this, much like we do
> with the CPUID common subset?
No reason. I can switch to that.

-Andi

