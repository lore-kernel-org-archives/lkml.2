Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab2EAPG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:06:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54793 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAPG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:06:57 -0400
Date: Tue, 1 May 2012 16:09:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Maarten Maathuis <madman2003@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120501160930.2f81538c@pyramind.ukuu.org.uk>
In-Reply-To: <20120501132352.GA28696@elliptictech.com>
References: <20120423024558.GD13840@phenom.dumpdata.com>
	<20120424010345.GA30674@elliptictech.com>
	<20120425013537.GA11959@elliptictech.com>
	<1335322574.1821.8.camel@nisroch>
	<1335504021.5311.0.camel@nisroch>
	<20120428003928.GA16805@elliptictech.com>
	<CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
	<20120428153350.GA19561@elliptictech.com>
	<20120429223744.GA19382@core.coreip.homeip.net>
	<CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
	<20120501132352.GA28696@elliptictech.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, this time bisecting started off relatively smoothly (doing the same
> "backwards" bisect on the branch-o-reverts as last time), but then my
> disk died halfway through...  So I'll post the partial bisection results
> now (11 commits left to test), but I clearly have other things to fix
> before I can get back to this issue.

You may get stupid answers because of

commit eeefa4bea1af34207c5299f989fffe03628ea164
commit 8353e6c632aeaea1470a286b83e68ca233073068

Been there, trying to chase down a GMA500 problemt that was muddled in
with the broken edid.h patch as well as a driver bug.

Alan
