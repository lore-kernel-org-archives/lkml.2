Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2DMOBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:01:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50667 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2DMOBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:01:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 13 Apr 2012 16:01:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120413160123.387e0a9b@stein>
In-Reply-To: <20120413154216.476a02ac@stein>
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
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 13 Stefan Richter wrote:
> there can only be two kinds of regressions in stable:
> 
>   A) First the regression was introduced into mainline, and accidentally it
>      was carried over from there into stable.
> 
>   B) The regression only happened in stable because a backport from
>      mainline to stable went wrong, e.g. a prerequisite to the backport
>      was forgotten to be backported beforehand.
> 
> AFAIU we are talking about a regression of type A.
> 
> It seems you are arguing that stable candidate patches which fix
> regressions of type A should be treated differently from other stable
> candidate patches.

Correction to the last sentence:
Type A has two subtypes:  A.1) The regression occurred in mainline between
the branch points v3.M and v3.N and resulted in a regression from v3.M.y
to v3.N.y.  A.2) The regression occurred in mainline after branch point
v3.N and resulted in a regression from v3.N to v3.N.y.

   A.1) Mainline and stable may be affected.
   A.2) Mainline and stable may be affected.
   B)   Stable is affected, mainline is not.

You seem to be arguing that best practices to fix A.1 issues somehow do
not apply to how to fix A.2 issues.  (They do apply though.)
-- 
Stefan Richter
-=====-===-- -=-- -==-=
http://arcgraph.de/sr/
