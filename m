Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936147Ab0GPJR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:17:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936087Ab0GPJR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T13HTGjIvDPD1bIynBmKSSerRNZp+ayta6Z/fXco0TkrAjeTPW6ZQGdgPzZfN4//V/
         rXR/rPCmdbdXahBEfCJoFAj30o5cDYiOQk8wfKKU9VGBUSFMjXylvVKVM9qgDuj7gu1B
         PxdlTtbF15azLdqAMAfM0lunNF6A5xRu9g1cw=
MIME-Version: 1.0
In-Reply-To: <AANLkTilv7cG9JMkZeO_GftTPWHxiIY5c8Q19pTBZT7Vy@mail.gmail.com>
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
Date: Fri, 16 Jul 2010 11:17:56 +0200
Message-ID: <AANLkTimGMUtzgO5HWHXX5RY-EDET61j6PxzwgILigIef@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 9:50 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Fri, Jul 16, 2010 at 10:37 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
>>> Let me know if you need more help with this.
>>
>> The next RC again hangs on me:
>>
>> http://www.flickr.com/photos/zrr/4798744700/sizes/l/
>
> Doesn't look like a kernel bug to me. Maybe some Gentoo person knows
> better but the 'root' parameter you pass to the kernel in your lilo
> configuration looks a little strange. You should try passing
> "/dev/sdXX" to it where XX is whatever partition your root filesystems
> is on.

This version has some problem with the DRM but no CPU eater yet.

http://www.flickr.com/photos/zrr/4798885756/

This version boots again just fine:

Linux zenogentoo 2.6.34-rc5-00059-gc2b4127 #105 SMP Fri Jul 16
11:13:21 CEST 2010 i686 Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz
GenuineIntel GNU/Linux

As I understand I am bisecting upwards. Every time it does not boot
correctly I do

git bisect bad after the next boot.

Best
Zeno
