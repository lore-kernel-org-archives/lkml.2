Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2GXKoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:44:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56854 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2GXKoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:44:05 -0400
Message-ID: <500E7C65.6040502@ti.com>
Date: Tue, 24 Jul 2012 06:43:49 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [RFC 01/23] ARM: LPAE: disable phys-to-virt patching on PAE systems
References: <1343092165-9470-1-git-send-email-cyril@ti.com> <1343092165-9470-2-git-send-email-cyril@ti.com> <20120724094143.GB20132@arm.com>
In-Reply-To: <20120724094143.GB20132@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 7/24/2012 5:41 AM, Catalin Marinas wrote:
> On Tue, Jul 24, 2012 at 02:09:03AM +0100, Cyril Chemparathy wrote:
>> From: Vitaly Andrianov <vitalya@ti.com>
>>
>> The current phys-to-virt patching mechanism is broken on PAE machines with
>> 64-bit physical addressing.  This patch disables the patching mechanism in
>> such configurations.
>
> It may be broken, I don't remember whether I tested this feature. What's
> the PHYS_OFFSET on your platform? Is it within the low 4GB range?
>

At boot time PHYS_OFFSET is 0x80000000, in the low 4G range. 
Subsequently we switch over to the high PHYS_OFFSET at 0x800000000 (see 
patch 23/23 of this series).

-- 
Thanks
- Cyril
