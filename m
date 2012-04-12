Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab2DLVja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:39:30 -0400
Received: from 1wt.eu ([62.212.114.60]:65077 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934773Ab2DLVj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:39:28 -0400
Date: Thu, 12 Apr 2012 23:39:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412213902.GA12807@1wt.eu>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com> <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com> <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com> <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 12:20:20AM +0300, Felipe Contreras wrote:
> The relevant patch, like the thousands of patches in v3.4-rc*, did not
> exist in v3.3, so if you add one on v3.3.1, and remove it on v3.3.2
> would be *exactly* the same as if you had not added it at all to the
> stable series.

Except that thanks to its addition in 3.3.1 we know it has broken some
setups. Now we know they're broken, there is a good reason to *ensure*
it is removed in 3.4-rc too. If you revert it from 3.3.2 and forget about
3.4-rc, you'll end up with the faulty patch present again in 3.4. It is
*very* important that -stable reflects what next should look like.

The only frustration from you that I can understand comes from the
multi-hop that the patch has to pass through before hitting Linus,
but for the same reason you want every intermediary maintainer to
ensure that his own tree is fixed so that the patch is not reintroduced
in a future batch.

Again, why don't you apply it into your tree ? Better, fork 3.3-stable
and announce 3.3.2-fc which has this patch. It will help other users too.
Let's just see how long you keep up with out-of-sync fixes.

Regards,
Willy

