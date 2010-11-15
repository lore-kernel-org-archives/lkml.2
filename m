Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0KOOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:41:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45594 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008Ab0KOOlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:41:50 -0500
Date: Mon, 15 Nov 2010 14:40:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
        Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: SCSI TMF processing; tag allocation
Message-ID: <20101115144029.5c322b78@lxorguk.ukuu.org.uk>
In-Reply-To: <1289831595.2233.5.camel@mulgrave.site>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
	<20101113123750.GF18258@parisc-linux.org>
	<4CE0FD24.4030000@fusionio.com>
	<1289831595.2233.5.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Realistically, tag starvation isn't really a problem.  It was a known
> issue for 80s era hardware.  I've got some of the oldest drives on the
> planet and I didn't see a problem when the clock algorithm was removed
> from 53c700.

I'm not entirely sure that is the case at least for some early NCQ
capable ATA drives 8(
