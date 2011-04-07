Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1DGQCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:02:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48993 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1DGQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=isJrxlRYXKC+Y7opRoBDNFFdwRk9W9lQ/DJpwgebTwisaZ1axX0Zm/Zn/283IwUGg1
         gMcpck2CUC3pJQXM3RkvQPVAxEvGcld2ZMdB3QtmuaWXUVAXaETrNnqm+apEkybxqW2y
         LCJ8WRyi699zfx4Pzao618UiuoYjezoz7rswY=
Message-ID: <4D9DDFF5.2010604@gmail.com>
Date: Thu, 07 Apr 2011 20:01:57 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: Hong Xu <hong.xu@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: MTD: atmel_nand.c: bug in the DMA support
References: <4D9DA8EC.7070604@gmail.com> <1302178277.2407.36.camel@localhost>
In-Reply-To: <1302178277.2407.36.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Artem,

Thank you for support!

Now it works.

Best regards!
--
Igor Plyatov

> On Thu, 2011-04-07 at 16:07 +0400, ext Igor Plyatov wrote:
>> Dear Hong,
>>
>> My machine is a Stamp9G20 module, from Taskit company, based on the
>> AT91SAM9G20 chip.
>> More details is here
>> http://armbedded.eu/documentation/pdf/stamp9g20technicalreference.pdf
>>
>> I have try to use Linux-2.6.39-rc2 (from Linus GIT) and discovered a bug
>> in the atmel_nand.c after yours patch.
>>
>> With the Linux-2.6.38.2 everything operate fine and here is a console
>> output shown:
> There were some fixes which are scheduled to be merged soon. Try
>
> git://git.infradead.org/mtd-2.6.git master
>
> which contains the fixes. This is the web view of that repository:
> http://git.infradead.org/mtd-2.6.git
>

