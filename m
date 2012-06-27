Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2F0Hc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:32:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36545 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2F0Hc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <1340767488.17253.4.camel@cr0>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
	<1340445863-16111-5-git-send-email-amwang@redhat.com>
	<CAMuHMdXkMBSkkXosJkd47n+RznpMBhzBGyLshA+gwdmZ=4dm6A@mail.gmail.com>
	<1340767488.17253.4.camel@cr0>
Date: Wed, 27 Jun 2012 09:32:57 +0200
X-Google-Sender-Auth: cPfq6vRmKS1_C5AcELx7iRQERPg
Message-ID: <CAMuHMdVVTvwyKWiyu=_XpLT3jEkZLe3QPyab5aCZuB+WD3Zkug@mail.gmail.com>
Subject: Re: [PATCH 04/12] frv: remove km_type definitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 5:24 AM, Cong Wang <amwang@redhat.com> wrote:
> On Tue, 2012-06-26 at 22:25 +0200, Geert Uytterhoeven wrote:
>>
>> "enum km_type" and "__KM_CACHE" are still used in
>> arch/frv/include/asm/highmem.h:
>
> Oops! I missed __KM_* types... Fortunately, the following patch could
> probably fix it.
>
> Thanks!
>
> ----------------------->
>
> All callers of kmap_atomic_primary() use __KM_CACHE, so it can be
> removed safely, and __kmap_atomic_primary() only check if 'type' if

s/if$/is/

> __KM_CACHE or not, so 'type' can be changed to a boolean as well.
>
> Ditto for kunmap_atomic_primary()/__kunmap_atomic_primary().

Looks OK to me (don't have the hardware). Thx!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
