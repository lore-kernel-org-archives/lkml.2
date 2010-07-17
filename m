Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0GQIqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 04:46:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0GQIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 04:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tef4FRsTuByx4pzczlXdfc379eiJs6nIGSIJG4kmwzDQib2YsoXFsBBqJTTjNVAqX9
         mmEjnHEf4WbgOx23rVJ/poUh+MWxQdAe7U1RgU6tijGuYmcYm1wuhgI1XCRs6MPiUV/F
         4exYP832dQkUwYxoNP4RQYjY3CiylQwtMjFKg=
MIME-Version: 1.0
In-Reply-To: <4C40C83E.2090900@kernel.org>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
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
	<AANLkTimxDBusBSkL0I2g9tsj4gLHaqVFArqcfixfzePh@mail.gmail.com>
	<4C40A498.5060208@kernel.org>
	<C36A97B2-E6A4-409D-91B8-DED8B086A479@gmail.com>
	<4C40C83E.2090900@kernel.org>
Date: Sat, 17 Jul 2010 10:46:26 +0200
Message-ID: <AANLkTikTLMGzaAvsmkD5Mcu54C0TclJMlxk2GbyBQ6eA@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 07/16/2010 01:29 PM, Zeno Davatz wrote:
>>
>> Am 16.07.2010 um 20:27 schrieb Yinghai Lu <yinghai@kernel.org>:
>>
>>> it seems that you are using 32bit kernel. please check if this one help.
>>
>> Thanks! What RC should I patch? 2.6.35-rc5?
>
> current linus tree or 2.6.35-rc5.

Tried to patch 2.6.35-rc5 but I get:

/usr/src/my2.6> sudo patch -p1 < patch_yinghai
patching file mm/page_alloc.c
Hunk #1 FAILED at 3634.
1 out of 1 hunk FAILED -- saving rejects to file mm/page_alloc.c.rej
patching file mm/bootmem.c
Hunk #1 FAILED at 833.
Hunk #2 FAILED at 986.
2 out of 2 hunks FAILED -- saving rejects to file mm/bootmem.c.rej

Any hints?

It seems that 2.6.35-rc1 does not have the CPU eater problem. I still
running it without any interference (though I was away from the
computer for some time).

Best
Zeno
