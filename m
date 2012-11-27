Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2K0T1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:27:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42854 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2K0T1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:27:00 -0500
Date: Tue, 27 Nov 2012 19:32:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
Message-ID: <20121127193208.331673ae@pyramind.ukuu.org.uk>
In-Reply-To: <50B50AA0.7070603@ilyx.ru>
References: <50B45A49.2040104@ilyx.ru>
	<20121127172406.GE24592@kroah.com>
	<50B50AA0.7070603@ilyx.ru>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No, if only you will accept:
> [PATCH]tty: Incorrect use tty_ldisc_flush() in TTY drivers.
> 
> It can be done another way, simple revert:
> 'tty: fix "IRQ45: nobody cared"'
> commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

NAK that revert - that swaps a minor glitch you've discovered that does
want fixing for a nasty bug.
