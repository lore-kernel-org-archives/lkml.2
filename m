Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1KIITt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:19:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33692 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1KIITs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <4EBA2DC5.5010907@snapgear.com>
References: <20111109111519.7d8969103ab32e7e8193c018@canb.auug.org.au>
	<4EBA26D9.3050108@snapgear.com>
	<CAMuHMdVsE4ZY3p8+kPgmKe5OOpoi1QV6BASK7gFYYTUDezyzLA@mail.gmail.com>
	<4EBA2DC5.5010907@snapgear.com>
Date: Wed, 9 Nov 2011 09:19:47 +0100
X-Google-Sender-Auth: wMAkRd6v2GS3-Ik7hdajAJ9qaqQ
Message-ID: <CAMuHMdW6qo2-Rg1vdB4_QMYTbhKyAFTiamy4z1zYhf0uQZB3-Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Nov 9, 2011 at 08:37, Greg Ungerer <gerg@snapgear.com> wrote:
> On 11/09/2011 05:13 PM, Geert Uytterhoeven wrote:
>> On Wed, Nov 9, 2011 at 08:08, Greg Ungerer<gerg@snapgear.com>  wrote:
>>>
>>> On 11/09/2011 10:15 AM, Stephen Rothwell wrote:
>>>>
>>>> Today's linux-next merge of the m68knommu tree got a conflict in
>>>> arch/m68k/Kconfig between commit d890d7399525 ("m68k/irq: Remove
>>>> obsolete
>>>> m68k irq framework") from the m68k tree and commit 4e8a9e70dfe8 ("m68k:
>>>> selection of GENERIC_ATOMIC64 is not MMU specific") from the m68knommu
>>>> tree.
>>>>
>>>> Just context changes. Ã¡I fixed it up (see below) and can carry the fix
>>>> as
>>>> necessary.
>>>
>>> Thanks. Both this and the previous m68k merge conflict patch look good.
>>>
>>> Geert: would you prefer I hold off on these 2 patches until after
>>> you merge your IRQ changes?
>>
>> I'll ask Linus to pull them today or tomorrow. After that (and he has
>> pulled), you can
>> rebase your tree. Is that OK for you?
>
> Yep, that is good. I wasn't sure if you where looking to push them
> in rc1 or in the next merge window.

rc2. I didn't want to rebase them to a random point between 3.1 and rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
