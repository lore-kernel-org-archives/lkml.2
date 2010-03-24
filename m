Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab0CXERb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:17:31 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:38725 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0CXERa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ftTv9qlO2htnFjtsTXaekbqdr1JcEiv+WGuVnxzXG//8zTcBuI7TQwcLW+9TdkvoR0
         Neq6hmmF05EArde/NoQxrpMjZ+MMZLDCmp8Sm5qk+4gtTagA7OqAk5SJaXILfXp4nCOe
         bGiX0HL5OYIWgVmAzC3NdYUbNzqz54+vIPutk=
MIME-Version: 1.0
In-Reply-To: <5712ce4f1003231735w33fb60a0h651c731fdbed747e@mail.gmail.com>
References: <QQGfxbJf48H.A.NFD.uNopLB@chimera>
	 <hTwaxgnIZ2O.A.DEE.3OopLB@chimera>
	 <5712ce4f1003211947i1a2ac84ch269885f7c2888c4f@mail.gmail.com>
	 <201003222224.47780.rjw@sisk.pl> <20100322212919.GB8941@lenovo>
	 <5712ce4f1003231735w33fb60a0h651c731fdbed747e@mail.gmail.com>
Date: Wed, 24 Mar 2010 07:17:28 +0300
Message-ID: <aa79d98a1003232117m168a3e37ud18c49554bffa82e@mail.gmail.com>
Subject: Re: [Bug #15392] The kernel does not start up.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: =?ISO-8859-1?Q?RALOVICH=2C_Krist=F3f?= <kristof.ralovich@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/10, RALOVICH, Kristóf <kristof.ralovich@gmail.com> wrote:
> On Mon, Mar 22, 2010 at 17:29, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Mon, Mar 22, 2010 at 10:24:47PM +0100, Rafael J. Wysocki wrote:
>>> On Monday 22 March 2010, RALOVICH, Kristóf wrote:
>>> > The issue is still there with 2.6.33-rc1, 2.6.33 and 2.6.33.1 too.
>>>
>>> Thanks for the update.
>>>
>>> Rafael
>>>
>>>
>> [...]
>>
>> (Out of thread)
>>
>> Hi Kristóf,
>>
>> I don't have time to take a closer look on this bug
>> but curious -- what will happen if you change compressing
>> method to say bz2, instead of LZMA being used now?
>>
>>        -- Cyrill
>>
>
> I took a look: I tested 2.6.33.1 with bz2 instead of LZMA, the same
> issue is still there.
>
> Kristof
>

Thanks, good to know
