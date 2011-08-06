Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1HFHCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 03:02:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40109 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1HFHCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 03:02:16 -0400
References: <20110727125651.GH3010@suse.de> <20110806065635.GE13220@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110806065635.GE13220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 06 Aug 2011 00:01:24 -0700
To: Ingo Molnar <mingo@elte.hu>, Mel Gorman <mgorman@suse.de>
CC: tglx@linutronix.de, bruno@ioda-net.ch, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Message-ID: <24c471f7-80f5-4102-a12b-d6245c8d0921@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

>
>* Mel Gorman <mgorman@suse.de> wrote:
>
>> ACPI reboot does not work for Dell Precision M4600. Detect this
>> machine via DMI and force the use of the PCI reboot method.
>>     
>> Reported-and-tested-by: Bruno Friedmann <bruno@ioda-net.ch>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>> ---
>>  arch/x86/kernel/reboot.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>
>Weird - ACPI is the default Windows method of reboot - how come it 
>does not work on that box? Does Windows work around this specific 
>machine (unlikely), or is our ACPI boot sequence not 100% compatible 
>with the Windows method (more likely IMO)?
>
>Thanks,
>
>	Ingo

It seems almost all the affected machines are Dell, too... very odd, no?
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
