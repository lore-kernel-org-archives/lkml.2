Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0KVNCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:02:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61729 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0KVNCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:02:02 -0500
MIME-Version: 1.0
X-Originating-IP: [192.102.204.37]
In-Reply-To: <AANLkTin3K_ffY8SeCo6JK570eDx_zHXzQ6ANA_ixy3tP@mail.gmail.com>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	<1290077254-12165-4-git-send-email-andi@firstfloor.org>
	<AANLkTinFxc5R-CgWv3XnoDrBcwQv_zwz1_4oCwTOOqGh@mail.gmail.com>
	<AANLkTin3K_ffY8SeCo6JK570eDx_zHXzQ6ANA_ixy3tP@mail.gmail.com>
Date: Mon, 22 Nov 2010 21:01:59 +0800
Message-ID: <AANLkTinbsQzDKvkZGkkc=pHuKvSyAXxdq8jC51jpjAd_@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Lin Ming <lin@ming.vg>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 8:47 PM, Stephane Eranian <eranian@google.com> wrote:
> On Mon, Nov 22, 2010 at 1:23 PM, Lin Ming <lin@ming.vg> wrote:
>> On Thu, Nov 18, 2010 at 6:47 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
>>> that can be used to monitor any offcore accesses from a core.
>>> This is a very useful event for various tunings, and it's
>>> also needed to implement the generic LLC-* events correctly.
>>>
>>> Unfortunately this event requires programming a mask in a separate
>>> register. And worse this separate register is per core, not per
>>> CPU thread.
>>
>> This "separate register" is MSR_OFFCORE_RSP_0, right?
>> But from the SDM,  MSR_OFFCORE_RSP_0 is "thread" scope,
>> see SDM 3b, Appendix B.4 MSRS IN THE INTEL® MICROARCHITECTURE CODENAME NEHALEM
>>
>> Or am I missing some obvious thing?
>>
> The manual is wrong on this.

Well, thanks for the info.
