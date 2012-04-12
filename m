Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886Ab2DLWEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:04:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51825 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab2DLWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:04:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
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
Date: Fri, 13 Apr 2012 01:04:42 +0300
Message-ID: <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
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

On Fri, Apr 13, 2012 at 12:34 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 12, 2012 at 2:20 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> I could argue in favor of exceptions, but I don't think you realize
>> the fact that this change does not affect your tree *at all*. Adding
>> and removing a patch in the stable tree is a no-op.
>
> You're a fucking moron.
>
> It's not a no-op at all, and you don't seem to understand it.
>
> It's *information*.
>
> It's "that patch didn't work". That's not a no-op. That's actual
> useful and worthwhile knowledge.

Sure, but removing that patch from the stable tree is not going the
change that information; we already know the patch is wrong.

Let's say somebody finds something wrong with one of the patches
proposed for 3.3.2 today, which is still a possibility. The patch
would be dropped, even though it's already in upstream (as all stable
patches are), and development in upstream will continue as usual, and
a proper fix will come later--there's lots of stuff broken there,
which is why not all the patches make it to 3.3.2.

But if somebody finds a problem on Saturday, after the 3.3.2 release,
well, it's too late now, the patch has been tagged and cannot be
removed for 3.3.3, now we have to wait to see what upstream does.

Wrong is wrong, before or after the 3.3.1 tag, this patch is not
'stable' material, and removing it does not affect upstream at all.

-- 
Felipe Contreras
