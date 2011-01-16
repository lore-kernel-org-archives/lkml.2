Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1APSbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:31:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40217 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1APSbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JIa9Ubo4kjoeK/xc8IHbHNafgYWQzF51Ua5sPgT1XUHqQOHNa6uPFQxu9XnapwbDFs
         gVotHwIAjOMU5yyBZNHufOUlfju8BSakTCXfInB8Tbhze3FtC02OxiOD4P6brcmi94yh
         h37c14Ic6pwHeqT/FI4MTCv/UiTn3zq/gs+OQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
	<AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com>
Date: Sun, 16 Jan 2011 20:31:10 +0200
Message-ID: <AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com>
Subject: Re: Please revert nouveau.
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 8:20 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 16, 2011 at 10:14 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>
>> Attached dmesg for 2.6.37-git14
>>
>> Until they test some more and present that, please revert.
>
> You need to describe the problem a lot more. Your dmesg doesn't even
> contain anything about nouveau or dri messages at all (or in fact
> anything that looks suspicious). So I think you really need to bisect
> where the (undescribed) problem started.
>
>                           Linus
>

This is not new: https://lkml.org/lkml/2010/12/31/37
And the bisect is really hard.
Please call for more testers, they will tell the same.
