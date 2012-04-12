Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966167Ab2DLW3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:29:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35413 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966124Ab2DLW3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
	<CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
	<CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
Date: Fri, 13 Apr 2012 01:29:46 +0300
Message-ID: <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 1:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 12, 2012 at 3:04 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> Sure, but removing that patch from the stable tree is not going the
>> change that information; we already know the patch is wrong.
>
> .. and we wait until it has been fixed in mainline so that we *know*
> that information doesn't get lost.

So why don't we pick potentially dangerous patches that might benefit
from some testing, put them in 'stable', and if there are problems,
make sure they get fixed in upstream first? Or for that matter totally
broken patches we want to make sure they get fixed in upstream.

Because the priority of the 'stable' tree is *stability*. Is it not?

But what you are saying is: *before* the final review, even a hint
that the patch might cause problems is reason enough to drop it from
stable, but *after* the review, if we know the patch is totally
broken, then it's the opposite; we really want it in.

-- 
Felipe Contreras
