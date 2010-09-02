Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0IBTx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:53:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54861 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab0IBTxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w1b3Zp9hCxuYo9G6g9/QONMGNdfZWpQQzlK05rYeQH3S+WJYTwQQcIPHfJtye/PNj0
         Lj2iU2QTG9HyZu6vUeppYWbjNAfGtBW1V/Pj3xphjVNF4ODX3q39PjwapiiZZozmW6Z3
         HvSTQu5fvIMXIRve/WO4svQdXsjf4xT+NxdPo=
MIME-Version: 1.0
In-Reply-To: <m38w3kns4r.fsf@hase.home>
References: <19747.1283422807@redhat.com>
	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
	<m38w3kns4r.fsf@hase.home>
Date: Thu, 2 Sep 2010 21:53:53 +0200
X-Google-Sender-Auth: pHR6ev5Kb_Qj1GzV0btg9dtXJaA
Message-ID: <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select
 m68knommu contributions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@redhat.com>
Cc: David Howells <dhowells@redhat.com>, gerg@snapgear.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 16:21, Andreas Schwab <schwab@redhat.com> wrote:
> David Howells <dhowells@redhat.com> writes:
>
>> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
>> the arch defines __uClinux__ for the build.
>
> You are using the wrong compiler.

it would be nice if you could use the same compiler for m68k and m68knommu, at
least for compiling kernels.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
