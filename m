Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1IRSGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:06:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63932 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1IRSG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:06:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110918.022125.1554085675403900813.davem@davemloft.net>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Sep 2011 11:06:08 -0700
X-Google-Sender-Auth: 3AMe-QgYyOYqRypW2XXxtAQIlNE
Message-ID: <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/17 David Miller <davem@davemloft.net>:
>
> dpward (2):
>      net: Make flow cache namespace-aware
>      net: Handle different key sizes between address families in flow cache
>
> nhorman (1):
>      net: don't clear IFF_XMIT_DST_RELEASE in ether_setup
>
> rajan.aggarwal85@gmail.com (1):
>      net/can/af_can.c: Change del_timer to del_timer_sync

Guys, if somebody has such a broken email setup that they don't even
show their own name, don't take patches from them.

If you cannot even set up email sanely, there is zero reason to
believe that the patch should be good. And if the patch is trivial and
you want to take it despite the source of the patch being crap, please
spend the five seconds to fix it up.

Proper names are part of the commit message. Don't make it look like
crap. I get ugly flashbacks to SVN or CVS when I see stuff like this.
Don't do it.

                          Linus
