Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2HAOl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:41:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab2HAOlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:41:25 -0400
Date: Wed, 1 Aug 2012 16:41:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "reiner.funck" <reiner.funck@web.de>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: no SMP
Message-ID: <20120801144127.GA7321@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"reiner.funck" <reiner.funck@web.de>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1955983.zBURmPy5y8@linux-joum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1955983.zBURmPy5y8@linux-joum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 01:59:09PM +0200, reiner.funck wrote:
> Dear Sirs,
> 
> I ask you for an advice. I get with all kernels (2.6, 3.1, ... 3.4) with all
> distributions (suse, ubuntu, ...) in the system messages
> ....
>                                                   CPU: Physical Processor ID:0
> Jul 17 11:52:47 linux-joum kernel: [    0.009100] CPU: Processor Core ID: 0
> Jul 17 11:52:47 linux-joum kernel: [    0.009101] mce: CPU supports 7 MCE 
> banks
> Jul 17 11:52:47 linux-joum kernel: [    0.009131] SMP alternatives 
> switchingto UP code
> Jul 17 11:52:47 linux-joum kernel: [    0.012309] Freeing SMP alternatives: 
> 20k freed
> Jul 17 11:52:47 linux-joum kernel: [    0.012347] weird, boot CPU (#16) not 
> listed by the BIOS.
> Jul 17 11:52:47 linux-joum kernel: [    0.012348] SMP motherboard not 
> detected.
> Jul 17 11:52:47 linux-joum kernel: [    0.113986] SMP disabled
> Jul 17 11:52:47 linux-joum kernel: [    0.113987] Performance Events: AMD 
> Family 15h PMU driver.
> Jul 17 11:52:47 linux-joum kernel: [    0.113989] ... version:                
> 0
> Jul 17 11:52:47 linux-joum kernel: [    0.113989] ..
> .....
> I work with Asus Mainboard M5A99X EVO and AMD FX(tm) 8150 (eight core) 
> processor. The Bios
> Version is the newest (1208, used with default options). The Results are equal 
> with Kernel
> option acpi=off or on, maxcpus=8 or not..
> Systemmonitoring shows one CPU.
> Bios must have the missing information? (weird, boot CPU (#16) not listed by 
> the BIOS).
> Asus replied to my question: we test no Linux systems (windows7 works with 8 
> cores).
> Do you have an advice for me?

Hmm, fun. Can you boot any kernel on your system successfully? If so,
can you send full dmesg from it?

Also, is it a 32-bit or a 64-bit kernel?

Also, can you test booting with "numa=off"?

Thanks.

-- 
Regards/Gruss,
Boris.
