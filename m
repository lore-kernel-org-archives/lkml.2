Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab2GGEs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 00:48:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2GGEsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 00:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <4FF6C958.9090809@grupopie.com>
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
 <4FF6C958.9090809@grupopie.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 7 Jul 2012 00:48:23 -0400
X-Google-Sender-Auth: TXjSC8oDvVM914gSBS7hvaYtqCo
Message-ID: <CAP=VYLqCNDo+3tz2RibPwwCNUNNYf1WA+wmeeUor8AmJqnfz1A@mail.gmail.com>
Subject: Re: "Inconsistent kallsyms data" error
To: Paulo Marques <pmarques@grupopie.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 7:17 AM, Paulo Marques <pmarques@grupopie.com> wrote:

[...]

>
> There was a recent thread from David Brown on the arm linux mailing list
> ("ARM: two possible fixes for the KALLSYMS build problem"). He tracked
> down the problem to having empty per_cpu sections on a non-smp build.

Actually rmk diagnosed it as the empty per_cpu sections.  See it here:

http://marc.info/?l=linux-next&m=133267456809502&w=2

Paul.
--

> The alignment of these sections made the symbols jump around and change
> from one build to the next. This particular problem might be ARM
> specific, though.
>
> --
> Paulo Marques - www.grupopie.com
>
> "I used to be indecisive, but now I'm not so sure."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
