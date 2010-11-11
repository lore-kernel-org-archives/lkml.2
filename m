Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0KKSoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:44:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:18999 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab0KKSoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:44:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,184,1288594800"; 
   d="scan'208";a="625871148"
Message-ID: <4CDC3974.3000506@linux.intel.com>
Date: Thu, 11 Nov 2010 19:44:04 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH/FIX] perf-events: Put the per cpu state for intel_pmu
 too
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>	<8762w3pxuy.fsf@basil.nowhere.org> <AANLkTi=-OjDaz9iDm1aNYzeFsHmewTNnGBS8pRx1vfJT@mail.gmail.com>
In-Reply-To: <AANLkTi=-OjDaz9iDm1aNYzeFsHmewTNnGBS8pRx1vfJT@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 6:54 PM, Stephane Eranian wrote:
> On Thu, Nov 11, 2010 at 6:35 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>> Small bug fix for the earlier offcore_response patch:
>> need to put the events for intel_pmu too, not only core_pmu.
>>
> You don't need it for core pmu, this is for Core Duo/Solo
> if I recall correctly.

It shouldn't matter because Core Duo doesn't have any per CPU resources, 
but
it seems more symetric to call it in any case.

It may make a difference if other users of the per CPU resource code get 
added.

-Andi

