Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0IHUvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:51:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56514 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754142Ab0IHUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:51:45 -0400
Date: Wed, 8 Sep 2010 22:11:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Lowe <nick.lowe@gmail.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
Message-ID: <20100908221144.73066e2d@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=FNFKmBgobH4q-GHguHM-0UOCQpa7JhPhyZZHG@mail.gmail.com>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
	<20100908185605.55671889@lxorguk.ukuu.org.uk>
	<AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
	<20100908200715.2e56d0be@lxorguk.ukuu.org.uk>
	<AANLkTi=FNFKmBgobH4q-GHguHM-0UOCQpa7JhPhyZZHG@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Those enterprise long term distributions aren't going to be
> targeting the Crusoe or Geode. It's not their market. Would they even

See this is the problem. You've forgotten *users*. It's easy to roll a
special kernel, its hell on earth 

> back port, therefore, if it was an issue?
> (This hypothetical anyway as it assuming they have an i686 targeted
> build already. Who does? Centos, RHEL and SUSE Enterprise are all i386
> targeted at the moment for x86.)

Wrong for some packages - and enough to break things. Bits like glibc for
example and chunks of X and proprietary apps.

>. (Again, hypothetical, as they're not targeted at i686!)

See above

> 4) As for proprietary apps, again, is it likely that they're targeting
> i686 already? Or is it far more likely they're compiled for i386 et.
> al.

Lots used -i686 because the compiler people said its faster and it works
on all 686 platforms. Neither of which it turns out is exactly true in
many cases.

> 6) What we are talking about is future distributions, whatever they
> are, that are now or are changing to target i686 which end users will
> ultimately want to migrate to and run.

s/we/you

Getting the stuff right in the current kernel makes it easier to backport
and fix and do tidily. It's not as if NOPL is complicated to emulate.
