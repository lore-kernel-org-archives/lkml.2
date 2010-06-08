Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0FHUgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:36:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58111 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab0FHUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VpNMryldYLeTf8I+IhlgkUzQqu+MkR+/Ek66ho/7y7PSA5atRh8N8eCxvau3l/WqMW
         wpVWEnduhbIkeBxTec9k23e2ioAbxBYbMYorGrP/A6P9Kqcg191vfZWjfM+zTuV9D+z5
         R+aj6CogS4cUPZYoVbuaMGcDOnUfwf3L2tKTs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006081313080.4506@i5.linux-foundation.org>
References: <4C0D3853.60000@petalogix.com>
	<alpine.LFD.2.00.1006081313080.4506@i5.linux-foundation.org>
Date: Tue, 8 Jun 2010 22:36:19 +0200
X-Google-Sender-Auth: S5kbZFm7h4Rn50ZtjY3-KJeXHRc
Message-ID: <AANLkTikeD21EtwtASzj8RksDqZyEof_kmUTnNr2HwwU2@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3 v2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 22:14, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, 7 Jun 2010, Michal Simek wrote:
>> here are only fixes for Microblaze. There is no any new features.
>> (flush_dcache_page patch fix problem on WB system)
>> Just note: Some new patches broke Microblaze arch that's why I would like to
>> add at least these patches to your tree.
>
> This _still_ doesn't seem to be "just regressions and major bugfixes for
> things like oopses and security issues".
>
> Why do I even have to send this email?

Seems like you will have written more angry emails than there will be
new commits in 2.6.35-rc3 ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
