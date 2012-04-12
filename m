Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966170Ab2DLVos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:44:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62538 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966078Ab2DLVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
 <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
 <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com> <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Apr 2012 14:44:24 -0700
X-Google-Sender-Auth: 32f1FD1qRqLXh5gArlI5AuIbUTE
Message-ID: <CA+55aFwa_wgBT85_Giy-23V5WpzRFrw9oCnFpTqVVam3DeG-7A@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 2:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So just reverting it from stable, *WITHOUT LEARNING THE LESSON*, is
> not a no-op at all, it's a sign of being a f*cking moron.

Btw, the revert is now in my tree (commit 011afa1ed8c4), and marked
for stable. So *now* Greg can revert it from stable too.

But the important lesson to everybody should be that "we don't lose
fixes from -stable". If a problem was found in stable, it needs to be
fixed upstream. In fact, quite often people *do* find problems in
stable, because it tends to have more users more quickly than
mainline. That makes it really really important to make sure that
those problems get fixed upstream, and not hidden in stable due to
some kind of dieseased "it's a no-op to revert it" thinking.

End of story.

                    Linus
