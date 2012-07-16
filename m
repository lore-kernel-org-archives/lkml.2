Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2GPOcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:32:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35739 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GPOcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:32:18 -0400
Date: Mon, 16 Jul 2012 15:36:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.5-rc7
Message-ID: <20120716153601.45a9d4db@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com>
References: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But go forth and test. Make sure it's all good. Because I really wish
> I won't have to do an -rc8.

Crahses and burns on Intel Poulsbo systems with a blank screen.
Fortunately I know why - your tree is short the patch for it that went to
Dave some time before -rc7. I'm just testing that v -rc7 now on the psb
boxes.

More strangely I also now get no backlight on one of the other
boxes despite it passing testing in previous -rc releases. I'm digging
into that but I do have an apparent workaround which just disables
backlight support as before on the relevant chip.

Alan
