Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab0E0EJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:09:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57788 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0E0EJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gqzq36twvc76xa2KOFr3jQGElHjxUZwS6k3+VMdNkWETGB4zBN9XH+GIwd2ClZTExn
         a8sDlQUh2aXIEdwvX8lXwLUINEVnbmV9HjMKJdbqNtjm8byZNEJAotNMWwBAAe//EORV
         eYuR1w2ehXBMaEbG8k5ZtT2A2dAqfEfs2lsJw=
MIME-Version: 1.0
In-Reply-To: <201005270213.42913.rjw@sisk.pl>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<201005270213.42913.rjw@sisk.pl>
Date: Thu, 27 May 2010 09:39:51 +0530
Message-ID: <AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Thu, May 27, 2010 at 5:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
>> Hello,
>>
>> I am trying to build 32 bit kernel image on 64-bit machine but after
>> 'make menuconfig' it automatically switches 32-bit to 64-bit.
>
> Try 'linux32 make menuconfig' and 'linux32 make'.
>

Yes, this works :-)

But I wonder then what is the point/use of CONFIG_X86_32 if compiler
is not listening to it.

Logically compiler should set appropriate flags based on .config settings.

Thanks,
--
Jaswinder Singh.
