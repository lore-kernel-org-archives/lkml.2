Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966181Ab2B2AkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:40:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45655 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965411Ab2B2AkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:40:20 -0500
Date: Wed, 29 Feb 2012 00:41:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, tilman@imap.cc, mac@melware.de, isdn@linux-pingi.de,
        jslaby@suse.cz, linux-kernel@vger.kernel.org, hjlipp@web.de,
        gigaset307x-common@lists.sourceforge.net, jirislaby@gmail.com
Subject: Re: "whitespace coding style cleanup" broke coding style
Message-ID: <20120229004156.7d17302d@pyramind.ukuu.org.uk>
In-Reply-To: <20120228.184246.556442272540134467.davem@davemloft.net>
References: <1330466751.21481.18.camel@joe2Laptop>
	<4F4D5E84.8090404@imap.cc>
	<1330471687.31737.19.camel@joe2Laptop>
	<20120228.184246.556442272540134467.davem@davemloft.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 18:42:46 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> 
> The truth is that isdn is unmaintained, so I just apply all ISDN
> patches directly after I review them, and I will continue to do so
> with impunity.

Except the Gigaset which has its own maintainer entry and active
maintainer...
