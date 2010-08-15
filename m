Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab0HOUNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 16:13:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49855 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604Ab0HOUNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 16:13:47 -0400
Date: Sun, 15 Aug 2010 21:28:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jon E <je_nfd@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Problems with Recent Patches to IDE Driver
Message-ID: <20100815212852.7c0e10ea@lxorguk.ukuu.org.uk>
In-Reply-To: <SNT135-w1108C18559F0BF8F0A3242F3980@phx.gbl>
References: <SNT135-w1108C18559F0BF8F0A3242F3980@phx.gbl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've googled for some answers but it seems there are no suggested workarounds for these problems.  Perhaps someone reading this can offer some suggestions?

Perhaps you could start by posting your patches ?

Most distributions have pretty much dropped the old IDE driver for
libata, which is actually better at supporting oddities so its probably
best to go that way.

Alan
