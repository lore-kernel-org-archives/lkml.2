Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2BBS76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:59:58 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:53200 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BBS75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:59:57 -0500
Date: Thu, 2 Feb 2012 19:59:54 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: select generic atomic64_t support
Message-ID: <20120202185954.GA18225@samfundet.no>
References: <1327243593-29215-1-git-send-email-fabio.baltieri@gmail.com>
 <20120124191031.GA20164@samfundet.no>
 <CABkP77eA9vMLA_V6E=LEy7vRZQP05DmKBRrje4eLbWNJwReyYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABkP77eA9vMLA_V6E=LEy7vRZQP05DmKBRrje4eLbWNJwReyYg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 02 Feb 2012 14:13:50 +0100 or thereabout, Fabio Baltieri wrote:

Hello,

>   yes, I think so. Do you want me to re-send the patch to some
> specific address? (like trivial fixes or so...).

Andrew does sometimes pick these small patches up, I would really like it to
go in as soon as possible. Try prefixing [RESEND] and add my Acked-by string.

.oO(I really need to find a kernel developer here in Oslo, so I can get a
proper account again.)

> On Tue, Jan 24, 2012 at 8:10 PM, Hans-Christian Egtvedt
> <egtvedt@samfundet.no> wrote:
>> Around Sun 22 Jan 2012 15:46:33 +0100 or thereabout, Fabio Baltieri wrote:
>>> Enable use of the generic atomic64 implementation on AVR32 platforms.
>>> Without this the kernel fails to build as the architecture does not
>>> provide its version.
>>
>> Thanks for the fix. I don't have an AVR32 tree currently, as I lost my access
>> to kernel.org. Could it be merged in with generic fixes?
>>
>>> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
>>
>> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>>
>>> ---
>>>  arch/avr32/Kconfig |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
>>> index 197e96f..3dea7231 100644
>>> --- a/arch/avr32/Kconfig
>>> +++ b/arch/avr32/Kconfig
>>> @@ -8,6 +8,7 @@ config AVR32
>>>       select HAVE_KPROBES
>>>       select HAVE_GENERIC_HARDIRQS
>>>       select GENERIC_IRQ_PROBE
>>> +     select GENERIC_ATOMIC64
>>>       select HARDIRQS_SW_RESEND
>>>       select GENERIC_IRQ_SHOW
>>>       select ARCH_HAVE_NMI_SAFE_CMPXCHG

-- 
mvh
Hans-Christian Egtvedt
