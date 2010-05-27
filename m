Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab0E0Q6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:58:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40840 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab0E0Q6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qULg0ma0dpQjCdwt8fiQ70vLnHXe0QEViH3JFvr2y0L4fRbOfB9P2pemElQ9UT6vkQ
         fIxzZCzBp44ly7ct3STR9DHjClW+DBL1l9TiM03FL+eXOu0+bns8im5ZPTiqGEDYMTik
         /4/YFXnQDH3A7KHyp+X87vbVuSULm9VeqDbXw=
MIME-Version: 1.0
In-Reply-To: <20100527095546.bb1bb941.randy.dunlap@oracle.com>
References: <AANLkTin1B96oeU50v0FPSJcVVFEKYos8-jM_i9eRiKxF@mail.gmail.com>
	<20100527095546.bb1bb941.randy.dunlap@oracle.com>
Date: Thu, 27 May 2010 12:58:13 -0400
Message-ID: <AANLkTilnr1yXcA_HAdKnlJwZZF6lb-mAoJSW9DXPMjUU@mail.gmail.com>
Subject: Re: [PATCH 2/4] [tip:x86/mm] Set first MB as RW+NX
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:55 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Hi,
>
>
> On Thu, 27 May 2010 12:52:21 -0400 Siarhei Liakh wrote:
>
>> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
>> index 4814d35..6dbcb6f 100644
>> --- a/arch/x86/Kconfig.debug
>> +++ b/arch/x86/Kconfig.debug
>> @@ -123,6 +123,17 @@ config DEBUG_NX_TEST
>>          and the software setup of this feature.
>>          If in doubt, say "N"
>>
>> +config DEBUG_SET_1ST_MB_RWNX
>> +       bool "Set 1st MB of kernel space mapping as RW+NX"
>> +       default n
>> +       depends on X86
>> +       ---help---
>> +         This option helps to catch unintended modifications/execution of
>> +         1st megabyte of kernel address space. Such protection may interfere
>> +         with run-time code patching and legacy BIOS services residing within
>> +         the 1st MB of physical address space.
>> +         If in doubt, say "N".
>
> Please spell out "first" instead of "1st" (all places in user-visible text).
>
> and gmail is space-stuffing your patches (converting tabs to spaces).
> Not good.  Are you using the gmail web interface for patches?
> That won't work AFAIK.  You'll need to use a real mail client.

Will do.
Thanks.
