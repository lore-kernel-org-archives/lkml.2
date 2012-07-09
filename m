Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2GINrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:47:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55341 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2GINrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:47:51 -0400
Date: Mon, 9 Jul 2012 14:51:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120709145126.313d1574@pyramind.ukuu.org.uk>
In-Reply-To: <20120709113558.GE8052@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
	<20120707231456.GA21201@arm.com>
	<20120708002920.4f55c737@pyramind.ukuu.org.uk>
	<20120709113558.GE8052@arm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > These are the same reasons the x86_64 people gave and regretted later.
> 
> I would not compare the x86_64 extension to the AArch64 architecture.


It's not an architecture specific observation. I was just observing that
you were following a pattern which in all other cases ended up with a
merged tree.

Now it could be your tree is different, it could be that the right
approach in all these cases is actually to do a new tree and merge five
years later - I don't know.

It's your (aarch64 folks) project at the end of the day and you who have
to keep all the fixes and errata and whatnot in sync between the two
trees and I don't personally care too much which way it happens.

Alan
