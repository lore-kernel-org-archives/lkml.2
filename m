Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab2GYNjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:39:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57393 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab2GYNjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:39:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6782"; a="214294096"
Message-ID: <500FF71A.7070303@codeaurora.org>
Date: Wed, 25 Jul 2012 09:39:38 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <500EFAA4.40600@codeaurora.org> <20120725084731.GB11389@arm.com>
In-Reply-To: <20120725084731.GB11389@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:47 AM, Catalin Marinas wrote:
> On Tue, Jul 24, 2012 at 08:42:28PM +0100, Christopher Covington wrote:
>> On 01/-10/-28163 02:59 PM, Catalin Marinas wrote:
>>> +- Architected timers
>>> +  CNTFRQ must be programmed with the timer frequency.
>>> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
>>> +  set where available.
>>
>> After Marc Zyngier's virtual timer patches come in, will the latter
>> requirement only be strictly necessary for kernels wanting to do
>> virtualization?
> 
> A kernel is usually entered at EL1 (rather than EL2) if it is a guest.
> In this case, the EL1PCTEN bit should have been enabled from the higher
> level to give access to the physical counter.

Ah right, those patches still use the physical counter for the
clocksource and cyclecounter interfaces.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
