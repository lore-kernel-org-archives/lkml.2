Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GTWHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:07:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47043 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1GTWHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:07:01 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110720093829.aae2ec63.rdunlap@xenotime.net>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
	<20110720093633.ca9cf794.rdunlap@xenotime.net>
	<20110720093829.aae2ec63.rdunlap@xenotime.net>
Date: Thu, 21 Jul 2011 00:06:59 +0200
Message-ID: <CA+icZUWeYkmrx+UF2Vfitx_6hnzzrGJk-wHC1gdEN0jMBznKtQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (acpi/apei/ghes)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 6:38 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 20 Jul 2011 09:36:33 -0700 Randy Dunlap wrote:
>
>> On Wed, 20 Jul 2011 18:00:41 +1000 Stephen Rothwell wrote:
>>
>> > Hi all,
>>
>> On i386 (X86_32):
>>
>> drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
>> drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression
>>
>> ghes.c:(.text+0x46289): undefined reference to `__udivdi3'
>>   in function ghes_estatus_cache_add().
>
> That's on:
>                period = duration / (count + 1);
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Same here on i386 with CONFIG_ACPI_APEI_GHES=y.

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `ghes_estatus_cache_add':
ghes.c:(.text+0x43d91): undefined reference to `__udivdi3'
make[4]: *** [.tmp_vmlinux1] Error 1

- Sedat -
