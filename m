Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab0GPJml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:42:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55100 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795Ab0GPJmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fIpsWINeJgClnaQxNqH8sz3/irBfX2Zd6hJNP8+QV3an5XwUZ+0JoT18J8QG5fxaMz
         2gfTg0kO4V/wPJ6v/ciOPqedliLy9LdyDoDvHENbuyQSeLjScrVItvmylyGWgIrj10q7
         j21c+aXd8nsjXwylnxd3L8YVlTjGg//muB+a8=
MIME-Version: 1.0
In-Reply-To: <4C40271E.9070809@cs.helsinki.fi>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	<4C3F2F52.2050101@cs.helsinki.fi>
	<20100715162805.GA10240@brouette>
	<20100715191638.GA3694@brouette>
	<AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	<20100715200012.GA4175@brouette>
	<F37ABC5E-E9F9-43BD-989E-4185135217D2@gmail.com>
	<AANLkTimWFTUZTh2-3Bavmwcum2joQluMEDmXx3xjyHqQ@mail.gmail.com>
	<AANLkTinqZs11kXx5afD4RDsVsy551S5lMnyAUwhdX2Sg@mail.gmail.com>
	<AANLkTilv7cG9JMkZeO_GftTPWHxiIY5c8Q19pTBZT7Vy@mail.gmail.com>
	<AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com>
	<4C40271E.9070809@cs.helsinki.fi>
Date: Fri, 16 Jul 2010 11:42:38 +0200
Message-ID: <AANLkTikKpzjQ9KTWx2i36bz0KjzKzBLhF-d4mtKEqczQ@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 11:32 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> No, you should only do "git bisect bad" if you find a CPU eater and "git
> bisect good" if you don't. For the non-booting kernels you should do "git
> bisect skip"; otherwise git gets confused as we can see here.
>
> Did you test v2.6.35-rc1? Does it have the CPU eater problem? If yes, please
> just reset your bisection
>
>  git bisect reset
>  git bisect start
>  git bisect good v2.6.34-rc7
>  git bisect bad v2.6.35-rc1
>
> and use 'git bisect skip' for kernels that don't boot or build.

Ok I done above and reboot onto the new bzImage:

This version looks fine.

Linux zenogentoo 2.6.34-04401-gf896546 #106 SMP Fri Jul 16 11:37:04
CEST 2010 i686 Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel
GNU/Linux

Best
Zeno
