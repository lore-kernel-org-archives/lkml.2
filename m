Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1J0KcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:32:01 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:51687 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1J0KcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:32:00 -0400
Message-ID: <4EA93311.30800@numascale.com>
Date: Thu, 27 Oct 2011 12:31:45 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 1/3] Add Numachip APIC support
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com> <20111027074449.GF15923@elte.hu>
In-Reply-To: <20111027074449.GF15923@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 09:44, Ingo Molnar wrote:
[]
>
> Note, while the merge window is in progress already, i think we can
> still add these patches slightly outside the merge window as well, as
> they add new hardware support and don't risk regressions elsewhere -
> if all the structural and fine-detail problems i pointed out during
> review are fixed.
>

Hi Ingo,

Thanks for the review, really appreciated. We'll go through your 
comments and redo the patchset. We'll probably leave out the PCI quirk 
patch this time since, as Bjorn Helgaas pointed out, it doesn't create a 
real conflict.

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
