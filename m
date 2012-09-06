Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2IFM4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:56:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46395 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2IFM4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:56:48 -0400
Date: Thu, 6 Sep 2012 14:01:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.4.10 N_GSM tty_io WARNING and lockup
Message-ID: <20120906140137.75ebe6ba@pyramind.ukuu.org.uk>
In-Reply-To: <m3k3w8g2m4.fsf@t19.piap.pl>
References: <m3k3w8g2m4.fsf@t19.piap.pl>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2012 12:56:03 +0200
khalasa@piap.pl (Krzysztof Hałasa) wrote:

> Hi,
> 
> I'm trying to use GSM tty line discipline. Basically
> 
> echo AT+CMUX=0 > /dev/ttyS0
> 
> set termios (speed etc.)
> int ldisc = N_GSM0710;
> ioctl(fd, TIOCSETD, &ldisc);

Baffled at this point. If you set some other ldisc instead (eg PPP) can
you reproduce it the same way ?
