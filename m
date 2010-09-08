Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0IHSrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:47:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32852 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752563Ab0IHSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:47:17 -0400
Date: Wed, 8 Sep 2010 20:07:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Lowe <nick.lowe@gmail.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
Message-ID: <20100908200715.2e56d0be@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
	<20100908185605.55671889@lxorguk.ukuu.org.uk>
	<AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And nobody has answered what happens when NOPLs are used to
> synchronise with something else? Surely that can lead to subtle, hard
> to debug breakage? Isn't that plain worse than refusing to run or
> breaking out of execution?

NOPL for synchronisation - of user space. I'd say thats sufficiently
unlikely not to care. It's still an improvement on crashing.

The other point you make is a good one but it's not clear that all the
proprietary apps for example will get recompiled, so to many users its
not a solution. Similarly the long term stable distros aren't going to
recompile everything and invalidate all their test data, so I doubt that
things like Centos will.

Alan
