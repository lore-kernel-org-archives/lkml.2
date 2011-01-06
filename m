Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1AFTYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:24:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54133 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AFTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:24:48 -0500
Message-ID: <4D26166D.1020009@zytor.com>
Date: Thu, 06 Jan 2011 11:22:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
References: <20110106094423.GA17565@elte.hu> <AANLkTinU423YzQxB9y7ZM9GQAYPQyTJUm9w18=6P_F88@mail.gmail.com>
In-Reply-To: <AANLkTinU423YzQxB9y7ZM9GQAYPQyTJUm9w18=6P_F88@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 10:55 AM, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 1:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> out-of-topic modifications in x86-apic-for-linus:
>> -------------------------------------------------
>> drivers/acpi/numa.c                # d3bd058: x86, acpi: Parse all SRAT cpu ent
> 
> Why is this x86-only? Aren't the same issues possible elsewhere?
> 
> Sure, ACPI is only used on x86 and ia64, and likely nobody cares about
> ia64, but that CONFIG_X86 still looks odd.
> 

Tony, as representative of the (ACPI - x86) universe, could you comment?
 I don't know if this is applicable on IA64.

	-hpa
