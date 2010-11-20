Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0KTMla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 07:41:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47866 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644Ab0KTMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 07:41:29 -0500
Date: Sat, 20 Nov 2010 12:40:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dr. Werner Fink" <werner@suse.de>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101120124020.43710d91@lxorguk.ukuu.org.uk>
In-Reply-To: <20101119184150.GA8997@boole.suse.de>
References: <20101118015310.GA30480@kroah.com>
	<20101118110020.GA13871@boole.suse.de>
	<20101118112335.434de53a@lxorguk.ukuu.org.uk>
	<20101118121256.GA19884@boole.suse.de>
	<20101118125822.16718289@lxorguk.ukuu.org.uk>
	<20101118131420.GA23872@boole.suse.de>
	<20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
	<20101119132145.GA22883@boole.suse.de>
	<20101119154705.7829487a@lxorguk.ukuu.org.uk>
	<20101119180258.GA6745@kroah.com>
	<20101119184150.GA8997@boole.suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uhmm ... just to say it: I've been asked by Fedorea people and also
> by Debian people why I had not submitted this patch and I've told
> them that I had it done long time ago ;)
> 
> It seems to me that there is some demand but most user space
> monitoring applications uses workarounds (AFAICR plymouth
> uses hard coded VT for boot and shutdown).

I think the market won the argument on this one - so please yes - submit
it.
