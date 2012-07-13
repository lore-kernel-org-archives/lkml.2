Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2GMLHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:07:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33163 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab2GMLHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:07:45 -0400
Date: Fri, 13 Jul 2012 12:10:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120713121053.0637219f@pyramind.ukuu.org.uk>
In-Reply-To: <20120713141345.f71b7c01f720d616d74721dd@canb.auug.org.au>
References: <20120713141345.f71b7c01f720d616d74721dd@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 14:13:45 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/char/mwave/mwavedd.c: In function 'register_serial_portandirq':
> drivers/char/mwave/mwavedd.c:472:2: error: implicit declaration of function 'serial8250_register_port' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> drivers/misc/ibmasm/uart.c: In function 'ibmasm_register_uart':
> drivers/misc/ibmasm/uart.c:57:2: error: implicit declaration of function 'serial8250_register_port' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Caused by commit 2655a2c76f80 ("8250: use the 8250 register interface not
> the legacy one").  Grep is your friend.

My fault on that one not GregKH's. I'll wrap that into the updated patch
series. I thought I had them all but I forgot to grep off in drivers/misc.

Alan
