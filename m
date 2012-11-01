Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312Ab2KAVdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:33:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887Ab2KAVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:32:58 -0400
Date: Thu, 1 Nov 2012 21:37:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
In-Reply-To: <20121101212843.GA20309@srcf.ucam.org>
References: <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	<1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012 21:28:43 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Nov 01, 2012 at 09:31:27PM +0000, Alan Cox wrote:
> > > Linux vendors may care about Linux on Linux attacks. It's all fun and 
> > > games until Oracle get Microsoft to revoke Red Hat's signature.
> > 
> > Fear uncertainty and doubt (and if you think Oracle are going to do that
> > I suspect your lawyers should deal with it)
> 
> Lawyers won't remove blacklist entries.

Fear Uncertainty and Doubt

Courts do, injunctions do, the possibilty of getting caught with theirs
hands in the till does.

But I suspect your lawyers should also deal with public comments about
Oracle such as the one you've made before you make them in public 8)
