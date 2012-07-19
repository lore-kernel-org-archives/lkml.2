Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2GSRbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:31:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2GSRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:31:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6777"; a="210048475"
Message-ID: <5008445B.2010109@codeaurora.org>
Date: Thu, 19 Jul 2012 13:31:07 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <50065E6B.3060602@jonmasters.org>
In-Reply-To: <50065E6B.3060602@jonmasters.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 02:57 AM, Jon Masters wrote:
> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> 
>> +- CPU mode
>> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
>> +  IRQ and FIQ).
>> +  The CPU must be in either EL2 (RECOMMENDED) or non-secure EL1.

Why not secure EL1?

> Even though this stuff is likely to be replaced with the result of some
> of the other standardization, I'd like it if you'd strongly consider
> removing the "or non-secure EL1". If you give an inch, someone will take
> a mile and build a system that enters other than in EL2. Or, something
> to the effect of "the highest non-secure exception level implemented"
> would be my preference if you don't want to specify.

I think it would be best to list the technical limitations, from the
kernel's perspective, of the unsupported exception levels and the
advantages of the supported exception levels here. If you want to guide
system builders towards EL2, I think it'd be more convincing to document
the relevant technical aspects (perhaps KVM needs facilities only
available in EL2) than just providing an unexplained requirement.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
