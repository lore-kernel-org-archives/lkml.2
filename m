Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab0KPLEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:04:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32926 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934030Ab0KPLEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:04:36 -0500
Date: Tue, 16 Nov 2010 11:03:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jesper Juhl <jj@chaosbits.net>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101116110310.1502de2a@lxorguk.ukuu.org.uk>
In-Reply-To: <34565.1289866395@localhost>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
	<34565.1289866395@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 5.6p1 is the latest-n-greatest released version on www.openssh.org, so somebody
> probably needs to rattle their chain...

But current openssh needs to support old kernels.

This is why this kind of obsoleting doesn't work well. It's not "update
your app" so much as "drop support for older stuff or start doing
complicated crap dependant on version"

and it's why for tiny amounts of code it is the *wrong* thing to force
obsolete stuff especially when it still doesn't seem to have been
properly marked for deprecation in the first place.

