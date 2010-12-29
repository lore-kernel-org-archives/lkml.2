Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0L2XfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:35:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45026 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0L2XfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GorkHhptl8KLSe5bPtkPjsJCniKQkv12Rll1/QIJEzbp2Q7baBOO9N6bsxgrx5kA/M
         5/wLUGFQL3AJqpYWodKaCdzYiygl91bhWWp6d4lok/nLOjeH4ovEJ1quxgYfZNxjMq8X
         Nnj0pciTRi25fifmSt/JIcdZGxuznmMThvYH0=
MIME-Version: 1.0
In-Reply-To: <AANLkTim=NTUtuAG=Gk=GeBHfTNM73xw6F8gjry6xsHs7@mail.gmail.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
	<20101229135315.5fe5c4e5@jbarnes-desktop>
	<AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
	<20101229151323.4a675097@jbarnes-desktop>
	<AANLkTim=NTUtuAG=Gk=GeBHfTNM73xw6F8gjry6xsHs7@mail.gmail.com>
Date: Thu, 30 Dec 2010 00:35:15 +0100
Message-ID: <AANLkTim51EAwzUqSJGQ4LnJbbPNCqbhyJumUd=_WkB+T@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 00:20, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Thu, Dec 30, 2010 at 00:13, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>> After closing and opening the lid (displays backlight is back)
>>>
>>>   http://vin-soft.org/~raa/public/test/intel_gpu_dump-after-lid
>>
>> I need the intel_reg_dumper output, not intel_gpu_dump. :)
>>
>
> Hmm, there is no intel_reg_dumper in intel-gpu-tools-1.0.2, which is
> the latest on http://xorg.freedesktop.org/archive/individual/app/,
> so I assumed you just mistyped the name. Is it in git only? ...
> Yeah, look like it is in git only, which I have problems to compile
> (I have a bit of obsoleted system).
>

Is there any other way to get at the dump? Because it looks like
it is plainly impossible to build the tools. A lot of dependencies,
all really hard to get at on Ubuntu Jaunty.
