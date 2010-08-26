Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0HZHUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:20:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43827 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0HZHUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EqwR9xKC27nm/Zdz6hlXPsrceeexuv5rNLmFJTuhLylaIKQgBhpMhXwKrwMP0muuex
         SuUh6kGBUssP/zgGpo4K2Xd7zaal6P7gMm4LmbDqE56gJ7Si79ntxyHE5Dzf49gn9SH6
         bqnQGVTtkcNRt7nKYAloGIyPFC2tBuExkmh/I=
MIME-Version: 1.0
In-Reply-To: <4C5A48B8.2060101@goop.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com>
 <20100804115658.GA21357@merkur.ravnborg.org> <AANLkTikz7pvirg7VUxrm-6v=yrLwHy4UeaJTS0wz3BLc@mail.gmail.com>
 <20100804202806.GA22134@merkur.ravnborg.org> <20100804204002.GA22147@merkur.ravnborg.org>
 <4C5A48B8.2060101@goop.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 26 Aug 2010 03:19:55 -0400
Message-ID: <AANLkTi=_1RE-UW=TSMGz58qcXi8WB++PeLcVswi8e=Pq@mail.gmail.com>
Subject: Re: missing .data.shared_align placement in vmlinux
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7Q7KRTG006388

On Thu, Aug 5, 2010 at 01:14, Jeremy Fitzhardinge wrote:
> Â On 08/04/2010 01:40 PM, Sam Ravnborg wrote:
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -150,6 +150,7 @@
>> Â #define DATA_DATA Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  \
>> Â  Â  Â  Â *(.data) Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â \
>> Â  Â  Â  Â *(.ref.data) Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â \
>> + Â  Â  Â  *(.data..shared_aligned) /* percpu related */ Â  Â  Â  Â  Â  Â  Â  Â  Â  \
>
> Typo? Â Shouldn't that be ".data.shared_aligned"? Â Or where does the '..'
> come from?

include/asm-generic/percpu.h:#define PER_CPU_SHARED_ALIGNED_SECTION
"..shared_aligned"
include/asm-generic/percpu.h:#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
include/asm-generic/percpu.h:#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
