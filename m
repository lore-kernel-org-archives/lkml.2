Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2JXF1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:27:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61569 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2JXF1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkghLrh61FvxcuQ3xKfX7=o-PhV390RN+9Ni+3fgJzMFJA@mail.gmail.com>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
 <87txu17lss.fsf@rustcorp.com.au> <CAKgNAkib2RZaHWP9bM0hC62=Nm5sBisQf_D9BAKNomjEPvCWbA@mail.gmail.com>
 <CAKgNAkghLrh61FvxcuQ3xKfX7=o-PhV390RN+9Ni+3fgJzMFJA@mail.gmail.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 24 Oct 2012 03:27:11 -0200
Message-ID: <CAKi4VA+tW30=8c18kNXVrw+v2x9=kQEYoF7Yjck6C98wHpNs0A@mail.gmail.com>
Subject: Re: [Request for review] Revised delete_module(2) manual page
To: mtk.manpages@gmail.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,


On Sun, Oct 21, 2012 at 5:36 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Ping!
>
> Rusty (et al.) I'm pretty sure the new page text is okay, but I would
> like someone knowledgeable to confirm.

One more thing:

> .SH "SEE ALSO"
> .BR create_module (2),
> .BR init_module (2),
> .BR query_module (2),
> .BR lsmod (8),
> .BR rmmod (8)

Shouldn't we remove the reference to query_module(2) and
create_module(2)? They don't exist anymore (and I miss a bigger
warning on their man pages).

Last, I think there should be a ref here to modprobe (because of -r
flag), not lsmod. The rest looks good.


Lucas De Marchi
