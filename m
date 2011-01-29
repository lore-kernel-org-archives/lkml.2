Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1A2Un5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 15:43:57 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:42355 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1A2Unz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 15:43:55 -0500
Message-ID: <4D447C00.70709@free.fr>
Date: Sat, 29 Jan 2011 21:43:44 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
References: <4D41EA12.1030402@free.fr> <201101272354.00042.rjw@sisk.pl>
In-Reply-To: <201101272354.00042.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki a écrit :
> On Thursday, January 27, 2011, matthieu castet wrote:
>> Hi,
>>
>> this patch merge 32 and 64 realmode wakeup code :
>> - this mean less ifdef in code
>> - we could remove now unused field in wakeup_header (pmode_*)
>> - this allow to set the first 1 MB NX.
>>
>> Do you think it is safe on all X86 32 bit machine ?
>>
>> Matthieu
>>
>>
>> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> 
> It _looks_ sane, but it will require some serious testing.  I'm not sure,
> though, if we can get enough testing coverage without actually committing
> that change.
> 
> How much testing has it received so far?
> 
Not too much only qemu with 1 and 2 core and a laptop with 1 cpu.

Please note that with this patch we can also remove the gdt, idt, ldt stuff from 
arch/x86/kernel/acpi/wakeup_32.S




Matthieu
