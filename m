Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1GDVws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:52:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243Ab1GDVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:52:46 -0400
Date: Mon, 4 Jul 2011 22:55:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Message-ID: <20110704225520.2d0004f3@lxorguk.ukuu.org.uk>
In-Reply-To: <201107042237.05295.arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<201107042127.31649.arnd@arndb.de>
	<20110704205336.09547e1f@lxorguk.ukuu.org.uk>
	<201107042237.05295.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How are people using those ISA cards today? The version of setserial
> that I found is not able to set MMIO mode on those. I suppose you

Various ugly hacks, if its tricky we can drop support and see who screams

> are not talking about isapnp cards, right? Those should not need to
> be handled through the ISA driver at all.

ISAPnP will do it automatically so the ISAPnP case isn't a problem. I've
never sen an ISAPnP port that was anything but standard.

