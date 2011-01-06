Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1AFQVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:21:38 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:64110 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1AFQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=N3vvg8aHo7LQLSrp4UlV2JhVhDYexdPyvHjSBQ1Wvm0nX0g7JE2Y71p4H+G+2BaeNG
         xy7a4XAOXxGFvynHrT6fM92yOn2PCQFhkisqY+T3QVcPcOUSkBF/Cp9sysOAz/tbyfmP
         XR0/4lletbY01i7+2x8aYdhA+Ngs1IsFtRWPI=
Message-ID: <4D25EC0C.9010409@gmail.com>
Date: Thu, 06 Jan 2011 17:21:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Jiri Slaby <jslaby@suse.cz>, len.brown@intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ia64: fix build of ioremap_cache
References: <4D257CD9.8060909@gmail.com> <1294302687-8051-1-git-send-email-jslaby@suse.cz> <alpine.LFD.2.02.1101061103010.17728@x980>
In-Reply-To: <alpine.LFD.2.02.1101061103010.17728@x980>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 05:03 PM, Len Brown wrote:
> 
>> diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
>> index 009a7e0..e5a6c35 100644
>> --- a/arch/ia64/include/asm/io.h
>> +++ b/arch/ia64/include/asm/io.h
>> @@ -428,7 +428,7 @@ extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size
>>  extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
>>  static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
>>  {
>> -	return ioremap(unsigned long phys_addr, unsigned long size);
>> +	return ioremap(phys_addr, size);
>>  }
> 
> I pushed this fix 9 days ago, what tree are you running?

Aha, you melded the fix into the original patch. I only checked whether
there was a change on the top of that commit. So ignore this patch and
sorry for the noise.

regards,
-- 
js
