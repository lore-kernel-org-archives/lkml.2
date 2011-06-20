Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1FTQEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:04:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59890 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1FTQD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:03:56 -0400
Message-ID: <4DFF6E58.8090306@zytor.com>
Date: Mon, 20 Jun 2011 08:59:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ryan Mallon <rmallon@gmail.com>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com> <4DFE89E0.5020509@zytor.com> <20110620074124.GB24716@elte.hu>
In-Reply-To: <20110620074124.GB24716@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 12:41 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> There are some test drivers which really want /dev/mem to work.
> 
> Test drivers and test hardware with zero enumeration can use below 4G 
> addresses just fine.
>
> Also, debugging is not an issue and some non-default kernel or boot 
> option can enable any sort of device i guess, so my main worry isnt 
> really security but that we should stand in the way of the apparent 
> practice of *shipping* user-space drivers that use /dev/mem ...
> 

We should either fix /dev/mem to work according to its specification or
rip it out.  The issue with test drivers is not spurious... I ran into
this one myself a few weeks ago while trying to do a memory test (by
limiting the amount of memory available to the kernel).  This is
something that is typically done on factory floors, and it would be nice
to be able to get those environments over to using Linux.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

