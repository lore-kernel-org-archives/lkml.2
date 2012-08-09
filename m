Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab2HIU6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:58:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37858 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2HIU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <1344545493-6820-1-git-send-email-mcgrof@do-not-panic.com>
References: <1344545493-6820-1-git-send-email-mcgrof@do-not-panic.com>
Date: Thu, 9 Aug 2012 22:58:27 +0200
X-Google-Sender-Auth: VJ9PDJBl_IqqJcWC40a_1jZBu9g
Message-ID: <CAMuHMdUd5x04KyyKa84J3PDB2xPj70xZLezwMJn1J=jwmzcnnA@mail.gmail.com>
Subject: Re: [PATCH] SubmittingPatches: clarify SOB tag usage when evolving submissions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: torvalds@linux-foundation.org, rdunlap@xenotime.net, tytso@mit.edu,
        alan@lxorguk.ukuu.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 10:51 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> of a second patch submission must supply their own Siged-off-by

Signed-off-by

> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -366,6 +366,21 @@ and protect the submitter from complaints. Note that under no circumstances
>  can you change the author's identity (the From header), as it is the one
>  which appears in the changelog.
>
> +If you are submitting a large change (for example a new driver) at times
> +you may be asked to make quite a lot of modifications prior to getting
> +your change accepted. At times you may even receive patches from developers
> +who not only wish to tell you what you should change to get your changes
> +upstream but actually send you patches. If those patches were made publicly
> +and they do contain a Singed-off-by tag you are not expected to provide

Signed-off-by

> +their own Singed-off-by tag on the second iteration of the patch so long

idem

> +as there is a public record somewhere that can be used to show the
> +contributor had sent their changes with their own Singed-off-by tag.

ditto

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
