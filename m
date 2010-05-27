Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0E0FXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:23:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40743 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0E0FXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=arSZxszcIHoZ0NbTchoL89IYIUy7w+ZgnIMp4hOw94nVfXWosXDxHXu9RE/RjGOA8w
         eldsqu9huVdoVnX/vUGBfGS6xN2qjxYUI2fWEJ887AO/hsALn23jTPL25qaptLM4zP6o
         TuCtgoZJQXod4kCf5JZqBdeXkb4SEt0tSj848=
MIME-Version: 1.0
In-Reply-To: <20100527043123.GA5349@cr0.nay.redhat.com>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<201005270213.42913.rjw@sisk.pl>
	<AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
	<20100527043123.GA5349@cr0.nay.redhat.com>
Date: Thu, 27 May 2010 10:53:41 +0530
Message-ID: <AANLkTilZ99VsmLuYoLlYItYAMtQQq6zTOQ2iEAdEm7pk@mail.gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:01 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
>>
>>But I wonder then what is the point/use of CONFIG_X86_32 if compiler
>>is not listening to it.
>>
>>Logically compiler should set appropriate flags based on .config settings.
>>
>
> It's not compiler, it's kbuild, kbuild tries to determine the arch
> by 'uname -m'.
>

Ahh, then kbuild is buggy, kbuild should check .config instead of
'uname -m' and verify from user if it mismatches.

Thanks,
--
Jaswinder Singh.
