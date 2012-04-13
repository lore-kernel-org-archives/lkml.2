Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab2DMK3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:29:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41427 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2DMK3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120413105746.10ffb120@stein>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
Date: Fri, 13 Apr 2012 13:29:46 +0300
Message-ID: <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:57 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Apr 12 Felipe Contreras wrote:
>> But this is exactly the opposite; the patch that broke things is in
>> the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
>> also on a later upstream, which is also broken.
>            ^^^^^
> No, upstream /earlier/ than 3.3.1 contains the defect.

Time is not relevant for the point being made, but fine:

But this is exactly the opposite; the patch that broke things is in
the 'release branch' (3.3.1); it's not in the upstream release from
where stable began (3.3). Sure, it's also on upstream, which is also
broken.

> Furthermore, consider this:  You as user of the 3.3.y series are using a
> temporary, dead-end side branch.  Its maintenance will stop at some point,
> and you will be left looking for a different, maintained series to migrate
> to.  You will be most interested in that series /not/ containing any
> regressions that you suffered already through the 3.3.y lifetime.

Of course, I will be interested in that, although most likely I would
be switching to another stable release (v3.4.1), not the upstream
release (v3.4), and most distros would do the same. Even in the
unlikely event that v3.4 is broken, most likely v3.4.1 would contain
the fix. But I'm also interested in v3.3.2 working.

So you are saying that:

a) v3.3.1 (bad), v3.3.2 (bad), v3.4 (good)
b) v3.3.1 (bad), v3.3.2 (good), v3.4 (bad)
c) v3.3.1 (bad), v3.3.2 (good), v3.4 (good)

b) is clearly better than a). Well, I don't see how; both situations
have the same number of releases broken, plus b) is very unlikely
anyway and we would end up with c). Plus, in all situation v3.4.1
would most likely contain the fix anyway.

> The rule is there to protect you, as a user of the stable series, from
> repeated regressions.

So in order to avoid b), you would rather go into a), than c)? Sorry,
I most definitely don't *need* that "protection". I guess I should
avoid the "stable" series then.

Cheers.

-- 
Felipe Contreras
