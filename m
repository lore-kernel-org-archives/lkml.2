Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab2DMI6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:58:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46768 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab2DMI6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:58:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 13 Apr 2012 10:57:46 +0200
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
Message-ID: <20120413105746.10ffb120@stein>
In-Reply-To: <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
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
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 12 Felipe Contreras wrote:
> But this is exactly the opposite; the patch that broke things is in
> the 'release branch' (3.3.1); it's not in upstream (3.3). Sure, it's
> also on a later upstream, which is also broken.
            ^^^^^
No, upstream /earlier/ than 3.3.1 contains the defect.

v3.4-rc1 is older than v3.3.1.

3.3 is not 3.3.y's upstream.  3.3 is the branch point from where 3.3.y
began.

torvalds/linux.git #HEAD is 3.3.y's upstream.
A git snapshot shortly before v3.4-rc1 was v3.3.1's upstream.

Furthermore, consider this:  You as user of the 3.3.y series are using a
temporary, dead-end side branch.  Its maintenance will stop at some point,
and you will be left looking for a different, maintained series to migrate
to.  You will be most interested in that series /not/ containing any
regressions that you suffered already through the 3.3.y lifetime.

That other 3.3+n.y kernel to which you will be wanting to migrate to
should obviously be based on a branch point which does not lack any of the
fixes which your last 3.3.y already had.

I.e. you require that stable kernels are branched off of good branch
points.  Mainline releases, i.e. releases of branch points, happen on a
time-based scheme (as opposed to a feature-based scheme).  So a rule whose
purpose is to ensure that future stable branch points contain all fixes
that earlier stable branches had already must necessarily be a time-based
rule.  This time-based rule is "fix mainline before stable".

The rule is there to protect you, as a user of the stable series, from
repeated regressions.
-- 
Stefan Richter
-=====-===-- -=-- -==-=
http://arcgraph.de/sr/
