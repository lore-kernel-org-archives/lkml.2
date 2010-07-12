Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0GLRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:48:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33786 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0GLRsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EzSIoAQuiZs6+tmMuC/wIFs/yG6XcB6ev5iLhft1GYdA3uIf9bMScIYB/AR60x+4Qj
         ZRWacbCwADs8YNk1THCdp/NxDGxQBQ493azf/v0sP8J2CB+IUs05cTM+zRpFWxaoHh33
         sQoZ+jQf7ZYDr+LSDc0hBvm0pFKGqF/EOS7eQ=
MIME-Version: 1.0
In-Reply-To: <4C3B3B39.2000809@davidnewall.com>
References: <201007110918.42120.Martin@lichtvoll.de>
	<20100711131640.GA3503@thunk.org>
	<4C3ABA35.7020507@davidnewall.com>
	<AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com>
	<4C3B3B39.2000809@davidnewall.com>
Date: Mon, 12 Jul 2010 19:48:02 +0200
Message-ID: <AANLkTinYljq6aZzRkchvWyOYpycElUuGi87UI3b9rdTe@mail.gmail.com>
Subject: Re: stable? quality assurance?
From: Marcin Letyns <mletyns@gmail.com>
To: David Newall <davidn@davidnewall.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/12 David Newall <davidn@davidnewall.com>:
>
> First, for the sake of brevity, I want it agreed that we're talking about
> new kernels, not those which are old, time-tested and patched.
>
> I didn't notice anyone say they want Linux development to slow down; >rather,
> and not just in this thread but in many threads before, that kernels
> released as "stable" fail to meet the common meaning of that word; and > this needs to be improved.

I remember when Greg (correct me if I'm wrong) said something like
there are no more stable releases. Those are distros which should
choose a 'proper' kernel. This seems to be working well: Ubuntu
usually ships with the one release older kernel, the same about
Debian, but they're much more restrictive and some other distros.
Those who wants to live on a bleeding edge they choose Fedora with the
latest kernel etc. Personally, I consider the LTS kernel is a stable
one and IMHO, like someone said in this thread before, the latest
mainline kernel shouldn't be called stable, but differently.

> Predictably, the common response sounds a bit like
> "shut up, go away, you're an idiot, it doesn't happen to me."  These are not
> useful as they serve not one whit to improve the situation, but give pause
> to those who might otherwise want to bring up a valid issue, once more.

Yes, I apologize for this. After reading your response now, such
complains are much more clear to me.

> There's no
> reason why development methods need to change in order to reduce the > number
> of flaky "stable" kernels.  It would be sufficient to replace the somewhat
> deceptive word "stable" with one that is more accurate; beta or gamma >test
> make sense as they already have industry acceptance.  Clearly "stable" is
> not appropriate, as implicitly agreed by others who have advised: "don't >use
> in production"; "wait at least a year"; and more.
>
> Thus 2.6.34 is the latest gamma-test kernel.  It's not stable and I doubt
> anybody honestly thinks otherwise.

This is the whole point IMHO. :D Fully agree with you here.

> As to whether other operating systems are stable, well that's a fair
> question.  I agree that few large bodies of computer code are flawless, and
> so stability can be relative.  In that spirit I venture to put the
> stipulated kernels into order of decreasing reliability: Best is BSD,
> Solaris & OS X; then Windows; and then there's Linux.  If named
> distributions had been included, the list would look better (for us); they'd
> go in the first group.  Thank goodness for the Debian, Red Hat and Novell
> (to name just a few) for giving the world something which does, at least
> largely, meet expectations.
>

In my opinion you shouldn't compare the latest Linux kernel (however,
such comparison would be fair if the latest Linux kernel would be a
'real' stable one) to other operating systems, but rather you should
just compare proper Linux distributions: Debian, RHEL to FreeBSD and
Solaris, OpenSuse, Kubuntu to Windows and OS X etc. Otherwise, it's
like comparing some *BSD development branch to Debian.

The similar situation to described in this thread is when comes to
Fedora. There are people (Linux newbies etc.) who can consider Fedora
is just an another ordinary, Linux distribution, but they're wrong.
Fedora usually ships with the latest, experimental stuff and if some
newbie (or even developer) decides to use Fedora and then he discovers
things simply brake he can consider Linux is a mess. Fedora shipped
with KDE 4.0 development release and even Linus was taken in, because
he probably thought it's a stable KDE release. Imho there should be a
notice what people have to deal with.
