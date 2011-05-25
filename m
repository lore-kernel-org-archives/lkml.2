Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1EYOIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:08:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45212 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab1EYOH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J3Qn6vDCbtfGEruQbdXJo44e/01nZXLvZbJ1RQqFdkCu6bZ32VWLsJv2PuciK/rsqq
         JvxaDv5KuNdme/xSTazRkUWYBOmFwkHnqLQkV26AaTuntp3pTinQzI4p4SVvt8tCWEfv
         9PgI4X6+JpLC9ax5M27xuNWh/VYB4PvTxdTgs=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=6xB6gyHt4caZwVEZ+qQQnMCTz-A@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<4DDBE4D5.9010000@gmail.com>
	<BANLkTi=6xB6gyHt4caZwVEZ+qQQnMCTz-A@mail.gmail.com>
Date: Wed, 25 May 2011 16:07:57 +0200
Message-ID: <BANLkTi=oF7kiZhu9COVJYk1vCcsW2UMpiw@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: Marco Stornelli <marco.stornelli@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        kmpark@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/25 Américo Wang <xiyou.wangcong@gmail.com>:
> On Wed, May 25, 2011 at 1:03 AM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> Il 23/05/2011 15:27, Stevie Trujillo ha scritto:
>>>
>>> Hello,
>>>
>>> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try
>>> to
>>
>> Yes, or at least was my intention. It's true that this drivers is useful
>> when you use an NVRAM, this is typical for the embedded world where the
>> platform driver approach is more diffused. Sure at this point the module
>> parameters are not useful. In addition the platform data struct doesn't
>> define a way to select if to dump only oops. At the end I think a patch it's
>> needed here. I have to look at the code to see if it's possible to use the
>> platform data OR module parameters. I'll submit a patch.
>>
>
> But we have the following code:
>
>        if (reason != KMSG_DUMP_OOPS &&
>            reason != KMSG_DUMP_PANIC &&
>            reason != KMSG_DUMP_KEXEC)
>                return;
>
> which is what you meant by saying "only oops" ?

I meant a way to set dump_oops parameter via platform data.

>
> I still don't think that is a correct way to tell people not to use
> ramoops, we need to document this rather than prevent using
> it in the code.
>

I really don't understand what you mean here.

Marco
