Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0ICJd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:33:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43518 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0ICJdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JNdmpwQYYJ79OjijjzpOjsKcDEkFmcTg+9grWZVCEIAjX5NyWkNwfE/OfZ+AHl3JGG
         be+Ta82VtluuLn0dlBVs3QYwT+qGHUPnFwTqL5faSDj+qrM7E7LytOduO04U/BOBER7Q
         yIe3aldC9G1niTVygRCH+ZGVn/rnxiSg2DtUg=
MIME-Version: 1.0
In-Reply-To: <4C80C068.1010302@snapgear.com>
References: <m3vd6nmd68.fsf@hase.home>
	<19747.1283422807@redhat.com>
	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
	<m38w3kns4r.fsf@hase.home>
	<AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
	<3048.1283505520@redhat.com>
	<4C80C068.1010302@snapgear.com>
Date: Fri, 3 Sep 2010 11:33:24 +0200
X-Google-Sender-Auth: B0tQiIl0Al6PRAZ3iLFkLg9XVgo
Message-ID: <AANLkTikBLCg_FUwGGiajw3+dgCe6y0s0a1yMs8=A2oCR@mail.gmail.com>
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select
 m68knommu contributions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: David Howells <dhowells@redhat.com>, Andreas Schwab <schwab@redhat.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 11:31, Greg Ungerer <gerg@snapgear.com> wrote:
> On 03/09/10 19:18, David Howells wrote:
>> Andreas Schwab<schwab@redhat.com>  wrote:
>>
>>> You are almost able to use the uclinux compiler for both, except that
>>> currently __uClinux__ is hardcoded.
>>
>> The m68knommu arch Makefile in the kernel could specify it on the compiler
>> command line, then m68k compilers should be possible.
>>
>> The kernel should probably also set appropriate -mcpu= and -mtune= flags,
>> depending on the type of kernel selected.
>
> Not sure about m68k but m68knommu targets already setup
> appropriate -mcpu flags for its various supported CPU types.

Same for m68k.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
