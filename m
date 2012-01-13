Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2AMTt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:49:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43774 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2AMTt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <CACsJy8BmFgssTAh=1U7JgBsGG-tSaWXQzZeODND3icXY3QUxug@mail.gmail.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <20120111184026.GA23952@windriver.com> <7vaa5rzaax.fsf_-_@alter.siamese.dyndns.org>
 <CACsJy8BmFgssTAh=1U7JgBsGG-tSaWXQzZeODND3icXY3QUxug@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 11:49:34 -0800
X-Google-Sender-Auth: jnLFKSvZBggjDLhAE5PAoAWZBhY
Message-ID: <CA+55aFxw_-0h1FDmPRVif3LM03Qh3-6haA7=KYbae8pSFbpW2w@mail.gmail.com>
Subject: Re: [PATCH] merge: Make merge strategy message follow the diffstat
To: Nguyen Thai Ngoc Duy <pclouds@gmail.com>
Cc: Junio C Hamano <gitster@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:27 AM, Nguyen Thai Ngoc Duy
<pclouds@gmail.com> wrote:
>
> Still, diffstat from a fetch/pull is sometimes too verbose. It'd be
> better if we have something that fit in one screen (dirstat or maybe
> just a first few lines from diffstat then ellipsis) then refer users
> to "git diff --stat HEAD@{1}" for more detail stat.

Yeah, I've wanted that. Show the beginning, the end, and the summary
line of the diffstat would be lovely.

It would be lovely in "git commit" too. Not just

    Modified: filename

but a diffstat that shows now many lines.

And what I've *really* wanted is to actually see the diff itself if it
is small. So some kind of "dynamic summary": for one-liners (or
ten-liners), show the whole diff. For medium-sized changes, show the
whole diffstat. And for really big changes, show an outline and the
"768 files changed, 179851 lines added, 7630 lines removed" stats.

IOW, whatever fits in, say, 50 lines or less.

That would be absolutely lovely if somebody were to do it.

                  Linus
