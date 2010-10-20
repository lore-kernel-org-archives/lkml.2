Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0JTJ1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 05:27:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65351 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0JTJ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 05:27:05 -0400
Date: Wed, 20 Oct 2010 12:26:38 +0300 (EEST)
Message-Id: <20101020.122638.112626316.Hiroshi.DOYU@nokia.com>
To: felipe.contreras@gmail.com
Cc: x0095840@ti.com, felipe.contreras@nokia.com, david.cohen@nokia.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <AANLkTimpmoDY+nDERsTQ_FK0k_vkPjOi=ttbdtt2LpPs@mail.gmail.com>
References: <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
	<20101020.114516.189725260.Hiroshi.DOYU@nokia.com>
	<AANLkTimpmoDY+nDERsTQ_FK0k_vkPjOi=ttbdtt2LpPs@mail.gmail.com>
X-Mailer: Mew version 7.0.50 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2010 09:26:44.0836 (UTC) FILETIME=[E9833240:01CB7038]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ext Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
Date: Wed, 20 Oct 2010 10:58:16 +0200

> On Wed, Oct 20, 2010 at 11:45 AM, Hiroshi DOYU <Hiroshi.DOYU@nokia.com> wrote:
>> From: "ext felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
>> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
>> Date: Wed, 20 Oct 2010 10:35:50 +0200
>>
>>> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
>>>> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
>>>> With this new API the valid range can be set.
>>>>
>>>> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
>>>
>>> I don't see the point in having an API. It could be done through
>>> platform data, and the usage of 0xFFFFF000 instead of ULONG_MAX is
>>> independent of this.
>>
>> Using platform data is better, but why dropping da_end?
> 
> Because it's always 0xFFFFF000. Do you know of any instance where
>it's not?

We should try to avoid forcing unnecessary limitations and
dependencies. The usage of device virtual address space range depends
on dsp(coprocessor) side S/W implimentation or configuration.
