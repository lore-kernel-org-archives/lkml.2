Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1EWV7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:59:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60944 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1EWV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=msEUI32xKnhme/ULTBreIL4OgF+fqEjrTgKiv40qMwwpjwLjBPDV0bkkh5BXmhRDzA
         AxmaZHtVVJ8L00T5IH4dk2FYSbVOMgEK+2Ny8ymh4UZZubtL2z1YIuCMoPhRDfYkb6UV
         Tl0kHftkr1xI/gr57yeNkbgepcEixs3xkoJZA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
Date: Mon, 23 May 2011 23:59:17 +0200
Message-ID: <BANLkTi=19n3pfEBBASFEeSwopBgOiN8Dtw@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/11, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> I really hope there's also a voice that tells you to wait until .42 before
>> cutting 3.0.0! :-)

I think, the best time for this, after reorganize the ARM arch folder / tree.

>
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.
>
> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
> fairly nice round number.
>
> There's also the timing issue - since we no longer do version numbers
> based on features, but based on time, just saying "we're about to
> start the third decade" works as well as any other excuse.
>
> But we'll see.
>
>                            Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
