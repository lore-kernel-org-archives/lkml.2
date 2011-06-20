Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1FTAqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:46:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1FTAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xlS3RtZR68akVsuqJKzbh9/f9dPzgBdRoahYjxjw9u01oLxd8OMVP/tMhLN+89G1kJ
         SEg4/GF2G7zQ1kzxDxSO/ANcqGLdPT1hH0PHHMwwZqQ4dJKX7VITsQpYwf/T6STlCVKS
         OJFxvXyTiB9Ghn0Dw5/K7tNdf0UWVa7IKbppo=
Message-ID: <4DFE9850.7030400@gmail.com>
Date: Mon, 20 Jun 2011 10:46:08 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ingo Molnar <mingo@elte.hu>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com> <20110620004252.GE19693@parisc-linux.org>
In-Reply-To: <20110620004252.GE19693@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/11 10:42, Matthew Wilcox wrote:
> On Mon, Jun 20, 2011 at 09:02:17AM +1000, Ryan Mallon wrote:
>> There are drivers where this makes sense. For example an FPGA device
>> with a proprietary register layout on the memory bus can be done this
>> way. The FPGA can simply be mapped in user-space via /dev/mem and
>> handled there. If the device requires no access other than memory bus
>> reads and writes then writing a custom char device driver just to get an
>> mmap function seems a bit overkill.
> Calling a 30 line device driver "overkill" might in itself be overkill?
>
I mean overkill in the sense of having to write the driver at all. Why 
write a 30 line driver just to re-implement some functionality of /dev/mem?

~Ryan

