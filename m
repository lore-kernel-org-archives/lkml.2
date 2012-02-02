Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2BBNNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:13:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40103 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2BBNNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120124191031.GA20164@samfundet.no>
References: <1327243593-29215-1-git-send-email-fabio.baltieri@gmail.com>
	<20120124191031.GA20164@samfundet.no>
Date: Thu, 2 Feb 2012 14:13:50 +0100
X-Google-Sender-Auth: MIsAah1b_lz7Sn3Vq3D1TM-2iFI
Message-ID: <CABkP77eA9vMLA_V6E=LEy7vRZQP05DmKBRrje4eLbWNJwReyYg@mail.gmail.com>
Subject: Re: [PATCH] avr32: select generic atomic64_t support
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  yes, I think so. Do you want me to re-send the patch to some
specific address? (like trivial fixes or so...).

Thanks!

On Tue, Jan 24, 2012 at 8:10 PM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Sun 22 Jan 2012 15:46:33 +0100 or thereabout, Fabio Baltieri wrote:
>> Enable use of the generic atomic64 implementation on AVR32 platforms.
>> Without this the kernel fails to build as the architecture does not
>> provide its version.
>
> Thanks for the fix. I don't have an AVR32 tree currently, as I lost my access
> to kernel.org. Could it be merged in with generic fixes?
>
>> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>
>> ---
>>  arch/avr32/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
>> index 197e96f..3dea7231 100644
>> --- a/arch/avr32/Kconfig
>> +++ b/arch/avr32/Kconfig
>> @@ -8,6 +8,7 @@ config AVR32
>>       select HAVE_KPROBES
>>       select HAVE_GENERIC_HARDIRQS
>>       select GENERIC_IRQ_PROBE
>> +     select GENERIC_ATOMIC64
>>       select HARDIRQS_SW_RESEND
>>       select GENERIC_IRQ_SHOW
>>       select ARCH_HAVE_NMI_SAFE_CMPXCHG
> --
> mvh
> Hans-Christian Egtvedt



-- 
Fabio Baltieri
