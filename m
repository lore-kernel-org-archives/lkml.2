Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1D3EUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 00:20:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab1D3EUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 00:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <web-515901951@zbackend1.aha.ru>
References: <web-515866242@zbackend1.aha.ru> <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com> <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk> <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
 <web-515898476@zbackend1.aha.ru> <BANLkTi=ujRJYG80F=HKqgz2nPeE5Gro+JA@mail.gmail.com>
 <web-515901951@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Apr 2011 21:20:29 -0700
Message-ID: <BANLkTi=o7NynvukkzE5ZhRHPu43=OV0_Ow@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 werner <w.landgraf@ru.ru>:
> The problem that the computer crashs if zip, unzip or move a big file,
> started with -rc1

Please do try to bisect..

> For being -rc5 , that kernel is rather bad. šI hope you get through to
> correct it until -rc10

Quite frankly, right now I think you're the only one that has reported
these kinds of problems, so we will need to rely on you to figure out
what is so odd about your setup.

If you can pinpoint when the crashes happened, that would help a lot.

Also, the crash that happens not-at-boot is in many ways way more
important. Clearly you have something odd going on after a reboot, and
I'd love to figure that out too, but in many ways the unzip one is way
more important.

Sadly, your previous mail had a nice picture, but the important
information had scrolled off the screen because of the ata1 exception
and command failed printouts. Any chance you could get a picture of
just the oops? If worst comes to worst, you might even have to disable
those ata debug printouts (normally they are really important, but if
they make the earlier oops scroll off the screen, they hurt more than
they help).

Oh, and please do an lspci -vvxx and a working dmesg too for that machine.

                  Linus
