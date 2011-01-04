Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1ADTeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:34:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1ADTeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JQMii960E6WbbwSvjfuEhfJpKjc91Q587/H4mI3/Ost8h90DvgF5RnsjS7r1Ntt9H7
         I4dSgBzegxAGADY5k2P5PIKIBaD1Evj77xcohkYDlnbW4jDwr4Q+f8W8nCys3eTcwW6k
         nU/FCu48UuQxRSlLMjhscYLKtJKDH1pCldR4w=
MIME-Version: 1.0
In-Reply-To: <60180.121.72.232.114.1294094426.squirrel@mail.orcon.net.nz>
References: <20110103205705.GA24522@gherkin.frus.com> <60180.121.72.232.114.1294094426.squirrel@mail.orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 4 Jan 2011 14:34:00 -0500
Message-ID: <AANLkTi=9xXBk6fgucRCLUdxUaY2PmqANyn8-rw5_Rv7A@mail.gmail.com>
Subject: Re: [BUG] 2.6.37-rc8 build failure on Alpha
To: Michael Cree <mcree@orcon.net.nz>
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 5:40 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> On Tue, January 4, 2011 9:57 am, Bob Tracy wrote:
>> This probably happened before -rc8, but was not an issue for 2.6.36.
>>
>> The 2.6.37-rc8 kernel build on alpha fails as follows:
>>
>> (...)
>>   LD      usr/built-in.o
>>   AS      arch/alpha/kernel/entry.o
>>   CC      arch/alpha/kernel/traps.o
>> cc1: warnings being treated as errors
>> In file included from
>> /usr/src/linux-2.6/arch/alpha/include/asm/mmu_context.h:22,
>>                  from arch/alpha/kernel/traps.c:26:
>> /usr/src/linux-2.6/arch/alpha/include/asm/io.h: In function '__set_hae':
>> /usr/src/linux-2.6/arch/alpha/include/asm/io.h:41: error:
>> 'arch_local_irq_save' is static but used in inline function '__set_hae'
>> which is not static
>> /usr/src/linux-2.6/arch/alpha/include/asm/io.h:49: error:
>> 'arch_local_irq_restore' is static but used in inline function '__set_hae'
>> which is not static
>
> A patch that fixes this was posted to linux-alpha some time ago (see
> http://www.spinics.net/linux/lists/linux-alpha/msg00710.html).  I am not
> sure why it hasn't made it through to Linus as yet.
>
> Cheers
> Michael.

I haven't had much time for alpha things, so I haven't been keeping up
with patches lately. I'll send everything in my patch queue to Linus
for the .38 merge window.

Please send Ivan's patch to Linus directly, and CC Ivan so he can give
his Signed-off-by tag.

Thanks Michael and Bob.

Matt
