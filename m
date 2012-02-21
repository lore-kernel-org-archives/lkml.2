Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2BUNC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:02:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58205 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2BUNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:02:25 -0500
Date: Tue, 21 Feb 2012 13:03:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, thomas@m3y3r.de, raven@themaw.net,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc4
Message-ID: <20120221130345.5c96ce60@pyramind.ukuu.org.uk>
In-Reply-To: <4F431BE8.1030201@zytor.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	<FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	<CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
	<20120219.144947.660678318380307878.davem@davemloft.net>
	<CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
	<4F431BE8.1030201@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm starting to think we should compile the kernel with -Wpadded by
> default (currently it's only done at "warning level 3", which I doubt
> anyone ever uses, especially since that also includes -Wpacked which is
> an actively toxic warning) and force people to add explicit padding
> where it needs to go, if necessary.  Unfortunately even that doesn't
> guarantee compatibility with userspace, but it's at least something.

We generate a set of believed correct export headers and check them these
days as an option. Can that work not be turned to do this. Ie create a
temporary .c file that includes all the user visible header data (without
KERNEL being defined) and runs it through -Wpacked etc

Alan
