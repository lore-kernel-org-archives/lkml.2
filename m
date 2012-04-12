Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934745Ab2DLVUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:20:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59722 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2DLVUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:20:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
References: <20120411231102.GA6404@kroah.com>
	<CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
	<20120412002927.GA23167@kroah.com>
	<CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
	<20120412011313.GA23764@kroah.com>
	<CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
	<20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
Date: Fri, 13 Apr 2012 00:20:20 +0300
Message-ID: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Apr 12, 2012 at 9:49 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>>
>>> A revert is the same as a patch.  It needs to be in Linus's tree before
>>> I can add it to the stable releases.
>>
>> Right, because otherwise people's systems would actually work.
>
> There are rules for a damn good reason.
>
> The rule for -stable is that the changes *have* to be in upstream, for
> a very simple reason: otherwise bugs get re-introduced.
>
> If -stable starts revertign things that aren't reverted up-stream,
> what do you think happens to the *next* kernel version?

Which is why nobody is trying to change the rules regarding that.

And your same argument applies to the all the thousands of commits on
the next kernel version; what would happen on the next kernel version?

The relevant patch, like the thousands of patches in v3.4-rc*, did not
exist in v3.3, so if you add one on v3.3.1, and remove it on v3.3.2
would be *exactly* the same as if you had not added it at all to the
stable series.

> I don't think you realize how well kernel development has worked over
> the last few years. And the stable rules are part of it.

I do understand how well the development works, which is why I often
use it as an example and guideline, but that doesn't mean it's
perfect.

> So stop complaining. Reverts really *are* just patches, Greg is 100%
> right, and you are simply wrong.

I could argue in favor of exceptions, but I don't think you realize
the fact that this change does not affect your tree *at all*. Adding
and removing a patch in the stable tree is a no-op.

> And the revert is now apparently in John's tree, and will make it to
> David and then me shortly. It will get reverted in stable too once
> that happens. In the meantime, your complaints are  to Greg only shows
> that you don't understand why the rules exist, and the fact that you
> *continue* to complain just makes you look stupid.

Is that going to happen before Friday? If not, then v3.3.2 will still
be broken *for no reason*.

-- 
Felipe Contreras
