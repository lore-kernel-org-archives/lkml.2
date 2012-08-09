Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2HILeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:34:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38790 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2HILeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:34:22 -0400
Date: Thu, 9 Aug 2012 12:38:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv2 1/4] modem_shm: Add Modem Access Framework
Message-ID: <20120809123855.1ba0fffb@pyramind.ukuu.org.uk>
In-Reply-To: <F45880696056844FA6A73F415B568C695B0E797048@EXDCVYMBSTM006.EQ1STM.local>
References: <1344322471-3640-1-git-send-email-arun.murthy@stericsson.com>
	<1344322471-3640-2-git-send-email-arun.murthy@stericsson.com>
	<20120807183809.GC26990@kroah.com>
	<F45880696056844FA6A73F415B568C695B0E796A03@EXDCVYMBSTM006.EQ1STM.local>
	<20120808133748.GA14459@kroah.com>
	<F45880696056844FA6A73F415B568C695B0E797048@EXDCVYMBSTM006.EQ1STM.local>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe tty can do this, but want to have all modem related  separately.
> There are many such hardware and many drivers coming up in near future.

tty can't do all this. We have similar things with stuff like CAIF. Modem
has gone from pretending to be a serial port (tty) to appearing as a
smart multi-function controller.

tty is the right way to expose any actual 'AT' modem emulation type
stuff, but it's not really relevant for most uses of a modern 3G/4G modem
- also also too slow !

Alan
