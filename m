Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1CEK23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:28:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52602 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861Ab1CEK22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:28:28 -0500
Date: Sat, 5 Mar 2011 10:28:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110305102821.4fed5ca4@lxorguk.ukuu.org.uk>
In-Reply-To: <20110304231031.GA27628@kroah.com>
References: <20110303211336.GA32645@kroah.com>
	<20110303214104.GZ3663@linux.intel.com>
	<20110303215155.GA30451@kroah.com>
	<20110303220735.GA3663@linux.intel.com>
	<20110303222226.GA30966@kroah.com>
	<20110304124348.6419c661@lxorguk.ukuu.org.uk>
	<20110304212851.GB28680@kroah.com>
	<20110304215915.18199ce1@lxorguk.ukuu.org.uk>
	<20110304221034.GD25574@kroah.com>
	<20110304223329.18a81f5f@lxorguk.ukuu.org.uk>
	<20110304231031.GA27628@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, I guess I must be doing support for distros that never get used :)
> 
> Have pointers to bug reports?

Not to hand it was some time ago at a previous employer and the fix we
agree ona anyway I think ?

> > You could have a standardised helper easily enough I guess. Pick a
> > standard struct and firmware descriptor and provide a
> > 
> > request_firmware_from_user(struct firmware_something __user *fw)
> > 
> > which hands back stuff in the form the rest of the firmware logic likes
> > to play and has a standard user side struct format.
> 
> Ok, patches gladly accepted :)

I'll have a look next week if I get a moment, it doesn't look hard.
