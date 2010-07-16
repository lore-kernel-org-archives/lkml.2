Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab0GPE1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:27:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45706 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0GPE1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rkw7MBk/GqUUv9713Kc7Ot7aEAgl0WvCtaHwBAhSy2A008HKQtMMmTPo9BDhYpkceq
         EVOvwl4RNgRAdX7dUof/YnwrC2VlVaSjZWt0ifTJC45bj5Tabkjpon6vXRcI113NGfDT
         r6N2/rTBcp31/NPqr1gZli6SnO2B1vs9sPY+k=
MIME-Version: 1.0
In-Reply-To: <4C3F7AD2.8050908@goop.org>
References: <AANLkTim2dCrCisUmunVsUoP3uSvYDvRvNPUD0eNFxPwj@mail.gmail.com>
	<4C3F7AD2.8050908@goop.org>
Date: Thu, 15 Jul 2010 22:27:01 -0600
Message-ID: <AANLkTikykqDZD6feCSi_sr8jlWOz71NsUQ12uo65DtIz@mail.gmail.com>
Subject: Re: Linux 2.6.28.10 and Linux 2.6.29.6 XEN Guest Support Broken 
	x86_64 in BUILD
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

building all versions of MDB (Merkey Debugger) on the kernels I missed
during my divorce.   Was busy with other things.  They are almost all
done.

Jeff

On Thu, Jul 15, 2010 at 3:17 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 07/14/2010 04:33 PM, Jeffrey Merkey wrote:
>> [root@cloudstream linux-2.6.29.6]#
>> [root@cloudstream linux-2.6.29.6]#
>> [root@cloudstream linux-2.6.29.6]#
>> [root@cloudstream linux-2.6.29.6]# make bzImage modules modules_install install
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   SYMLINK include/asm -> include/asm-x86
>>   CALL    scripts/checksyscalls.sh
>>   CHK     include/linux/compile.h
>>   AS      arch/x86/xen/xen-asm_64.o
>> arch/x86/xen/xen-asm_64.S: Assembler messages:
>> arch/x86/xen/xen-asm_64.S:48: Error: suffix or operands invalid for `mov'
>> arch/x86/xen/xen-asm_64.S:55: Error: suffix or operands invalid for `test'
>> arch/x86/xen/xen-asm_64.S:72: Error: suffix or operands invalid for `mov'
>> arch/x86/xen/xen-asm_64.S:90: Error: suffix or operands invalid for `test'
>> arch/x86/xen/xen-asm_64.S:110: Error: suffix or operands invalid for `setz'
>> arch/x86/xen/xen-asm_64.S:116: Error: suffix or operands invalid for `cmp'
>> make[1]: *** [arch/x86/xen/xen-asm_64.o] Error 1
>> make: *** [arch/x86/xen] Error 2
>> [root@cloudstream linux-2.6.29.6]#
>>
>
> Do you have a particular reason to be using those kernels?  They're very
> old.
>
>    J
>
