Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1JUFdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:33:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:64989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1JUFdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:33:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,383,1315206000"; 
   d="scan'208";a="64821623"
Message-ID: <4EA1040A.8010705@linux.intel.com>
Date: Fri, 21 Oct 2011 13:32:58 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Huang Ying <ying.huang@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add IRQ context simulation in mce-inject
References: <4E7707DA.6080504@linux.intel.com> <4E77AC54.2080305@linux.intel.com>
In-Reply-To: <4E77AC54.2080305@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/20 4:55, Andi Kleen 写道:
> On 9/19/2011 2:14 AM, Chen Gong wrote:
>> From: Chen Gong <gong.chen@linux.intel.com>
>>
>> Current mce-inject can simulate some kinds of scenarios, such as
>> one CPU working in process context, and other CPUs working in NMI
>> context. To extend the coverage of test range, a new IRQ context
>> for other CPUs is added.
>
> Looks good to me.
> -Andi
>
> --

Hi, Andi

I will resend this patch, do you agree I add you as the "Signed-off-By"
in the next post?

