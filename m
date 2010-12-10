Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0LJCEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:04:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27613 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab0LJCEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:04:37 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jon Nelson <jnelson@jamponi.net>,
        "Ted Ts'o" <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>,
        Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt barrier support is effective)
In-reply-to: <AANLkTimXznTKJAk7NAQPJC1op8iozsRCT5CHYm72hkkq@mail.gmail.com>
References: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com> <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com> <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org> <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com> <20101209180111.GF2921@thunk.org> <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com> <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com> <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think> <AANLkTimXznTKJAk7NAQPJC1op8iozsRCT5CHYm72hkkq@mail.gmail.com>
Date: Thu, 09 Dec 2010 21:00:07 -0500
Message-Id: <1291946360-sup-154@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Mike Fedyk's message of 2010-12-09 20:58:40 -0500:
> On Thu, Dec 9, 2010 at 5:38 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > Excerpts from Andi Kleen's message of 2010-12-09 18:16:16 -0500:
> >> > 512MB.
> >> >
> >> > 'free' reports 75MB, 419MB free.
> >> >
> >> > I originally noticed the problem on really real hardware (thinkpad
> >> > T61p), however.
> >>
> >> If you can easily reproduce it could you try a git bisect?
> >
> > Do we have a known good kernel?  I looked back through the thread and
> > didn't see any reports where the postgres test on ext4 passed in this
> > config.
> >
> 
> 2.6.34.something.  -- Any chance a newer kernel can be tested to be found good?

But he is triggering the ext4 corruption without dm-crypt.  I think
dm-crypt was still used somewhere on the system during the test, just
not on the partitions that actually hit the corruption.

-chris
