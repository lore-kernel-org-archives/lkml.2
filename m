Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1EYWVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:21:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38581 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1EYWVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xLDtt+e0vYnuwE5muOkTcRymUqjt/zLRK7tKw9/9h4KjqxMtE1Xm1k8ZTKSJwaVaqr
         2xK4XjZLVuEPK4lNQvgygFpm8f8kIGVmg0BxNgXN5/1nhan4I+qXO6sB91yvwjDpVpY/
         MORXYScIVvYSfpteM5JK4rsR3aslwgredheD8=
MIME-Version: 1.0
In-Reply-To: <4DDD0E5F.5080105@panasas.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
	<4DDD0E5F.5080105@panasas.com>
Date: Wed, 25 May 2011 15:21:00 -0700
X-Google-Sender-Auth: IOpmaxbWCufxgdck9dklybc9nG8
Message-ID: <BANLkTi=FAwzW+qR+Cbwmor90pgbgzfuw-g@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: Tony Luck <tony.luck@intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 7:12 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> So if you combine all the above:
>
> D. Y. N
> D - Is the decade since birth (1991 not 1990)
> Y - is the year in the decade so you have 3.1.x, 3.2.x, .. 3.10.x, 4.1.X and so on
>    Nice incremental number.
> N - The Linus release of this Year. So this 3rd one goes up to 4 most probably.
>
> Linus always likes, and feels very poetic about the Christmas version release.
> He hates it when once it slipped into the next year. So now he gets to increment
> the second digit as a bonus.
>
> The 2nd digit gets to start on a *one*, never zero and goes up to *10*, to symbolize
> the 1991 birth. And we never have .zero quality, right?
>
> The first Digit gets incremented on decade from 1991 so on 2011 and not 2010

This is clearly the best suggestion so far - small numbers, somewhat
date related (but without stuffing a "2011." on the front).  No ".0"
releases, ever.

But best of all it defines now when we will switch to 4.x.y and 5.x.y
so we don't have to keep having this discussion whenever someone thinks
that the numbers are getting "too big" (well perhaps when we get to the
tenth decade or so :-)

So the only thing left to argue is whether the upcoming release should
be numbered "3.1.1" as the first release in the first year of the 3rd
decade ...  or whether we should count 2.6.37 .. 2.6.39 as the first
three releases this year and thus we ought to start with "3.1.4" (so we
start with "pi"!).

Linus: If you go with this, you should let Boaz set the new "NAME"
as a prize for such an inspired solution.

-Tony
