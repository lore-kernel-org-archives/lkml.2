Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0K2VH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:07:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43592 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0K2VH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:07:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ifKSMFrutPe5Cn9pZe+gT1ngFd0XB00M0Rp3wOSeQ3zcyn8Mc4tm6FqTEq4ZS1LmzD
         7AYPthvtYsUfW860ratIgZqEl3SZyxXtQu94Iid7A5pbGxU6v9vbpsz9T4gydpO+6tSG
         zKMOWT0ms/ebdf+Ru3j3KNZ+S9L9VXbrkeHXk=
MIME-Version: 1.0
In-Reply-To: <AANLkTim299hoNcUhBU3j6MN248QsbQC7+R67CrgdF_b3@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	<20101129081619.GD5218@cr0.nay.redhat.com>
	<AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	<20101129085250.GF5218@cr0.nay.redhat.com>
	<AANLkTikmzhM-XpXrtOys3DbrG00brnXx0YVYSpHt-vrs@mail.gmail.com>
	<AANLkTim299hoNcUhBU3j6MN248QsbQC7+R67CrgdF_b3@mail.gmail.com>
Date: Mon, 29 Nov 2010 22:07:25 +0100
Message-ID: <AANLkTin+PwqYVDZq+mwT4Bioz6108pZ7=zfsSb0WhPg3@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:00 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Mon, Nov 29, 2010 at 3:51 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Mon, Nov 29, 2010 at 9:52 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>>> [...]
>>> No, I didn't mean this, I meant some function that have to be inlined
>>> are those who only work when being inlined, e.g. current_text_addr().
>>
>> Can you please explain to me why some functions work only when they are inlined?
>> Is it because of asm() black magic?
>>
> obviously, you do not understand the purpose of this function...

this is why i was asking!

anyway, now i got it.
thanks to peter zijlstra for the kind explanation on #kernelnewbies.

>  - Arnaud
>

-- 
Thanks,
//richard
