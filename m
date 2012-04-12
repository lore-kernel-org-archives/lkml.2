Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2DLRY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:24:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2DLRY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
Date: Thu, 12 Apr 2012 10:24:55 -0700
X-Google-Sender-Auth: Onc3zftnEIGyrjPuN5exBaB26Sk
Message-ID: <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Adrian Chadd <adrian@freebsd.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 April 2012 09:49, Felipe Contreras <felipe.contreras@gmail.com> wrote:

>>
>> A revert is the same as a patch.  It needs to be in Linus's tree before
>> I can add it to the stable releases.
>
> Right, because otherwise people's systems would actually work.
>
> But hey, as I said, following rules is more important, regardless of
> what the rules are, and why they are there. The rules that actually
> triggered this issue in v3.3.1, as this is not in v3.3.
>
> You could just accept that the patch should have never landed in
> v3.3.1 in the first place, but it's much easier to arbitrarily keep
> stacking patches without thinking too much about them.

Greg is doing the right thing here. We face the same deal in FreeBSD -
people want fixes to go into a release branch first, but if you do
that you break the development flow - which is "stuff goes into -HEAD
and is then backported to the release branches."

If you don't do this, you risk having people do (more, all)
development and testing on a release branch and never test -HEAD (or
"upstream linux" here). Once you open that particular flood gate, it's
hard to close.

We had this problem with Squid. People ran and developed on Squid-2.4.
The head version of Squid-2 was stable, but that isn't what people ran
in production. They wanted features and bugfixes against Squid-2.2,
squid-2.4, and not Squid-2.STABLE (which at the time was
Squid-2.6/Sqiud-2.7.) That .. didn't work. Things diverged quite
quickly and it got very ugly.

So I applaud Greg for sticking to correct stable release engineering
here. We over in the BSD world know just how painful that is. :)


Adrian
