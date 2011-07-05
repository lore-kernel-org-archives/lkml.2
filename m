Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1GESBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:01:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1GESBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:01:51 -0400
Message-ID: <4E135056.3060906@zytor.com>
Date: Tue, 05 Jul 2011 10:56:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
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
References: <201106171038.25988.ptesarik@suse.cz> <201107012134.45881.ptesarik@suse.cz> <20110701195629.GA19057@elte.hu> <201107012244.57593.ptesarik@suse.cz> <20110703194618.GB27022@elte.hu> <20110705174901.GA30531@srcf.ucam.org>
In-Reply-To: <20110705174901.GA30531@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 10:49 AM, Matthew Garrett wrote:
> On Sun, Jul 03, 2011 at 09:46:18PM +0200, Ingo Molnar wrote:
> 
>> But those tables wont be in regular RAM (they will be in ROM or in 
>> RAM marked non-RAM in a special way in the e820 tables).
>>
>> dmidecode certainly works on Fedora.
> 
> I've repeatedly wanted to dump EFI data that's flagged as E820_RESERVED 
> above the top of RAM and had to hack the kernel every time. I'm entirely 
> in favour of not having to hack the kernel every time.
> 

That definitely needs to be fixed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

