Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0G0Oxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:53:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47073 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111Ab0G0Oxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:53:44 -0400
Date: Tue, 27 Jul 2010 16:05:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philippe Langlais <philippe.langlais@stericsson.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
Message-ID: <20100727160533.653fb5c0@lxorguk.ukuu.org.uk>
In-Reply-To: <4C4EF132.7090304@stericsson.com>
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>
	<12798430773066@site>
	<20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
	<4C4E9064.6070001@stericsson.com>
	<20100727091408.49d55447@lxorguk.ukuu.org.uk>
	<4C4EF132.7090304@stericsson.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have such a platform driver, but I can't see anywhere an example of 
> set_termios()
> or another uart_ops function overriding.

The example I referenced shows you how to provide your own
serial_in/serial_out.

You will need to adjust the 8250 driver to add another function pointer
and copy it so that you can also override set_termios.

Alan
