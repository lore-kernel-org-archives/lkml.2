Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2GQJ6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:58:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36920 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2GQJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:58:43 -0400
Date: Tue, 17 Jul 2012 11:02:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Arapov <anton@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Josh Hunt <joshhunt00@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Kerneloops.org defunct?
Message-ID: <20120717110207.33cb6d8a@pyramind.ukuu.org.uk>
In-Reply-To: <1342507240.21627.8.camel@bandura>
References: <4DE6264A.2040901@gmail.com>
	<20110601212432.2677b03a.rdunlap@xenotime.net>
	<201106211534.10366.roucaries.bastien@gmail.com>
	<CAE2SPAa=AD=YGyLJn2bX4E8Mu70BaXGi2CvL_fikPKP1gab7+g@mail.gmail.com>
	<20110826173517.7321c086@lxorguk.ukuu.org.uk>
	<CAE2SPAYuYTYj9ukDzitKs+d2uKZacJ5eFo7N+-p9pWgf1MWW2w@mail.gmail.com>
	<20120625180536.GA29261@roeck-us.net>
	<4FE8A9C0.3050802@linux.intel.com>
	<20120625191233.GA29324@roeck-us.net>
	<20120626071430.GA16299@bandura.brq.redhat.com>
	<1342507240.21627.8.camel@bandura>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   The reporting tool(Abrt) complicated the reporting and kerneloops.org
> DNS still doesn't associated with the required ip address. ( Arjan? )

Anton - just talk to the kernel.org maintainers and get oops.kernel.org
set up somewhere and be done with it.

>   - Starting from the Fedora 18 kernel oopses reporting will be
> configured to send reports unconditionally, straight to the
> kerneloops.org as it did the original tool.
> (this, hopefully, will fix the volume of the oopses we are getting.)

And probably the volume of complaints about spyware. It should be asking
permission even if "until further notice" is a choice.

For some environments this is a major issue. Consider people with ARM or
x86 prototype machines who are contractually forbidden from revealing a
lot of data about the systems.

Alan
