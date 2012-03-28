Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2C1K6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:58:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40009 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2C1K6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:58:09 -0400
Date: Wed, 28 Mar 2012 12:00:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Paul G. Allen" <pgallen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Support for Perle SXPCI Universal Serial Cards
Message-ID: <20120328120040.616a4588@pyramind.ukuu.org.uk>
In-Reply-To: <CAN4-gUF33wb=4Ry7em_-4Hp-OTWDmnSJjzJmE_0c-J4S_mhU2A@mail.gmail.com>
References: <CAN4-gUF33wb=4Ry7em_-4Hp-OTWDmnSJjzJmE_0c-J4S_mhU2A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can anyone tell me if this card is currently supported in a recent
> Linux kernel (the last kernel I have seen support in is 2.6.9), or if

The rio and sx drivers had no maintainer and have security holes and
other problems so when nobody stepped up they went in the recycling.

> deal with Windows 7, or upgrade to Linux, even if it means porting the
> older Perle code to a newer kernel.

The generic serial layer has gone (and is unfixably insecure without
major rewrite), the core tty code has changed a fair bit too - so it'll
need some porting over to the tty_port infrastructure instead but the low
level stuff should all be pretty much fine.

If someone does that work then there's no reason it can't go back into
the tree. We just ran out of people who cared about it with everyone now
using USB or the vast array of PCI 16x50 based generic boards.

Alan
