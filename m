Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965823Ab2FBUBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:01:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49233 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965741Ab2FBUBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com> <1338402812.2760.413.camel@edumazet-glaptop>
 <4FC66D3D.6080509@fusionio.com> <1338404902.2760.451.camel@edumazet-glaptop>
 <1338410107.2760.544.camel@edumazet-glaptop> <1338456918.2760.1318.camel@edumazet-glaptop>
 <1338574627.2760.1545.camel@edumazet-glaptop> <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
 <1338583498.2760.1648.camel@edumazet-glaptop> <20120601215620.305155c0@pyramind.ukuu.org.uk>
 <1338584389.2760.1653.camel@edumazet-glaptop> <1338621438.2760.1679.camel@edumazet-glaptop>
 <1338623708.2760.1691.camel@edumazet-glaptop> <1338624102.2760.1693.camel@edumazet-glaptop>
 <20120602125723.5b057570@pyramind.ukuu.org.uk> <1338640231.2760.1704.camel@edumazet-glaptop>
 <CA+55aFwXrX16ufu1yf_D8rXTPXfpN1D72STuNYOMqT57je+jRA@mail.gmail.com> <CA+55aFysA72FVTF6k=HnqYjCTqXQO+jcMLeR6MpM=eJm-H+EBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Jun 2012 13:01:29 -0700
X-Google-Sender-Auth: qAdo6ujgVLUvsggv12i3nkx3Rdg
Message-ID: <CA+55aFxnrQqUioiF1TdAAR3xSuqq3mam_pWvt6ZyeQEAW=J79A@mail.gmail.com>
Subject: Re: [PATCH] tty: add lockdep annotations
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 12:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I *think* this makes sense. But it has has had absolutely zero
> testing. It compiles in my config, and the locking is at least
> sensible and well-localized, but maybe I'm missing something.

Ok, it boots for me. For whatever that is worth.

              Linus
