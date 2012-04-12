Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868Ab2DLVee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:34:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50225 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2DLVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
 <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com> <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Apr 2012 14:34:10 -0700
X-Google-Sender-Auth: qvgIErl_t7u2M18ITuiDFXafp6A
Message-ID: <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
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

On Thu, Apr 12, 2012 at 2:20 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>
> I could argue in favor of exceptions, but I don't think you realize
> the fact that this change does not affect your tree *at all*. Adding
> and removing a patch in the stable tree is a no-op.

You're a fucking moron.

It's not a no-op at all, and you don't seem to understand it.

It's *information*.

It's "that patch didn't work". That's not a no-op. That's actual
useful and worthwhile knowledge.

To quote Thomas Edison: "I have not failed. I've just found 10,000
ways that won't work."

So just reverting it from stable, *WITHOUT LEARNING THE LESSON*, is
not a no-op at all, it's a sign of being a f*cking moron.

I'm stupider for just reading your email. Go away.

                    Linus
