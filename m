Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0LOXdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:33:09 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:60998 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0LOXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:33:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dEsFFOGMU80IVGrwFp3k7boS9+sEvh61Ixg/BlWlLhtIK7q9pgxZHeb0ph/J+msRpi
         yAMk4jDI7IzVL35wLgdHy7//bXNjrhyXMa/6pLqDNr1zRK4B/2JmQzYMggbWZfRzu/TV
         ZUGGANGyxG6WXy5hjOE6gnu/VcNjCn0w4Bhbc=
MIME-Version: 1.0
In-Reply-To: <20101215221454.GB6560@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
	<AANLkTikuWubUkGp2nESWTLz+kQsczznh7fuixdLzMfdO@mail.gmail.com>
	<20101215221454.GB6560@dtor-ws.eng.vmware.com>
Date: Thu, 16 Dec 2010 01:25:27 +0200
Message-ID: <AANLkTindv4GUp3E8Vzkzm_JzGxxOP+TdaAsVhxrEVOw6@mail.gmail.com>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:14 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> On Wed, Dec 15, 2010 at 02:06:03PM -0800, Alexey Dobriyan wrote:
>> On Thu, Dec 16, 2010 at 12:00 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
>> > Currently only drivers that are built as modules have their versions
>> > shown in /sys/module/<module_name>/version, but this information might
>>
>> Can you create just /sys/module/x?
>> Module version info is quite useless by itself.
>
> It is as useful as in the case where driver is built as a module. I am
> just trying to unify the behavior a bit.
>
> Code-wise it is almost as cheap to add /sys/module/x/version as adding
> just the directory.

OK.

Still, people are using /sys/module/x presence as indicator of modular
built (unsurprisingly).

http://codesearch.google.com/codesearch/p?hl=en#wZuuyuB8jKQ/src/third_party/autotest/files/client/profilers/powertop/src/bluetooth.c&q=/sys/modules&sa=N&cd=3&ct=rc&l=105
