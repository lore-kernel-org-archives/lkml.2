Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1LWUkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:40:51 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1LWUks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:40:48 -0500
Date: Fri, 23 Dec 2011 20:40:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: markh@compro.net
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: tty  TTY_HUPPED anomaly
Message-ID: <20111223204015.541924f2@pyx>
In-Reply-To: <4EF4CC92.5090502@compro.net>
References: <4EF49579.9040907@compro.net>
	<4EF4CC92.5090502@compro.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I turned the TTY_DEBUG_HANGUP and added some additional printks. You see 
> below the first port works just fine but the second fails because 
> something is calling the tty_hangup function around 70usecs after I open 
> the device???
> What and Why???

The driver will be - and because the carrier dropped and the HUPCL flag
is set on the port.

Alan
