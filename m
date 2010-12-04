Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0LDRsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 12:48:54 -0500
Received: from mail.perches.com ([173.55.12.10]:2228 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab0LDRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 12:48:53 -0500
Subject: Re: [PATCH 1/2] vsprintf: Add %pMbt, bluetooth mac address
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <AANLkTi=qh0GKp3BdKO9GX1qmM3iJ6J_F3fLqZ8qNAw5v@mail.gmail.com>
References: <cover.1291419007.git.joe@perches.com>
	 <a33a0b00eeb29713a08d91156cbb2d816176f990.1291419007.git.joe@perches.com>
	 <AANLkTi=qh0GKp3BdKO9GX1qmM3iJ6J_F3fLqZ8qNAw5v@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Dec 2010 09:48:51 -0800
Message-ID: <1291484931.31274.21.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-04 at 12:03 +0100, Michał Mirosław wrote:
> 2010/12/4 Joe Perches <joe@perches.com>:
> > Bluetooth output the MAC address in reverse order.
> > Adding %pMbt allows the batostr function to be removed.
> Just a nitpick:
> You could call it %pMR, as in 'Reverse', so it sounds better when/if
> some other subsystem uses it. It would also be a hint of what is this
> doing instead of where it came from.

I considered that but believe %pMbt is clearer as most
likely no other subsystem will be quite so far (out to
lunch? in left field?  north? :) enough to do that again.

If any maintainer wants it changed, it's not any sort
of problem to me, say so and I'll resubmit it.

