Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0KJU4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:56:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35309 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756651Ab0KJU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:56:48 -0500
Date: Wed, 10 Nov 2010 20:55:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101110205532.03060e6e@lxorguk.ukuu.org.uk>
In-Reply-To: <20101110003524.GL3099@thunk.org>
References: <20101109223225.5e261346@lxorguk.ukuu.org.uk>
	<20101110003524.GL3099@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> alternative, and is higher priority than any other consideration.  If
> a product had 33% less battery lifetime, but was developed in
> mainline, would you buy that over a standard product?  OK, maybe a

That's if you believe the Google thing that it can't be done any other
way. Which other vendors don't seem to be agree with.

> OTOH, if the original poster thinks that he can develop changes to the
> Android userspace that allow the use of an upstream kernel, and has
> just as good battery lifetime, and with a system which is just as
> debuggable and easy to maintain as the current android userspace, then
> by all means, I would love for him to try to prove that he can.  And I
> will certainly be happy to introduce him to the Android developers who
> measure power usage in mobile devices using microwatt meters to see if
> he really can do as good of a job using a stock kernel.

Well actually there is a much better simple reason. One of the things you
get by using a standard kernel is the ability to dump a true Android
environment onto another device that's running something else as well.

I don't quite understand why people play some of the strange games they
do but being able to dump them on arbitary Linux platforms is no doubt
useful.

Alan
