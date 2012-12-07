Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2LGJ7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:59:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56154 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2LGJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:59:14 -0500
Date: Fri, 7 Dec 2012 10:04:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 8250 UART doesn't work
Message-ID: <20121207100438.136dd968@pyramind.ukuu.org.uk>
In-Reply-To: <slrnkc2o7b.2ck.narkewoody@zuhnb712.local.com>
References: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
	<50C0E737.2000201@zytor.com>
	<slrnkc2o7b.2ck.narkewoody@zuhnb712.local.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The UART controller is EXAR ST16C554D.  It claims as a 16550
> compatible controller. Each ST16C554D module contains 4 UART, each of
> them can be selected via two chip select pad. I think the board
> hardware, via a CPLD, make the chip selection transparent to the CPU, so
> by a 5-bit address, CPU can addressing individual 8 16550 compatible
> registers of each UART.

The EXAR should work. Make sure you have all the addressing and setup
right would be my first suggestion - then poke at the registers by hand
and double check.

Alan
