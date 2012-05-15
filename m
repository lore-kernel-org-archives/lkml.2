Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965877Ab2EOQda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:33:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45485 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661Ab2EOQd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:33:26 -0400
Date: Tue, 15 May 2012 17:36:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Message-ID: <20120515173613.3c8c2f1f@pyramind.ukuu.org.uk>
In-Reply-To: <1337099344.13455.9.camel@x61.thuisdomein>
References: <1336491453.1933.67.camel@x61.thuisdomein>
	<Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
	<20120515153539.GA25206@kroah.com>
	<1337099344.13455.9.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 18:29:04 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Tue, 2012-05-15 at 08:35 -0700, Greg Kroah-Hartman wrote:
> > > > Of course, an easy way out would be to downgrade both the "Asking for
> > > > cache data failed" and the "No Caching mode page present" errors to
> > > > notices. But the SCSI people might disagree with that approach.
> > > 
> > > Well, let's see what they say.
> > 
> > What ever happened here, are these 3 patches acceptable, or do they need
> > to be reworked or something else?
> 
> Nothing happened after Alan's message.
> 
> So, currently only the first patch was acceptable (to Alan, that is, but
> it touched the SCSI code).
> 
> At least, I haven't seen a reply from the SCSI people. Perhaps the best
> thing to do is to submit a series of one or two trivial patches that
> just downgrade the errors involved to notices. That should lead to
> feedback by the SCSI people.

Possibly we should have a hostadapter flag indicating if the cache noise
is expected nuisance or not. That way if hardcore SCSI on real cables
wants to keeep it then it can still be shut up for USB where its the
norm and just irrelevant noise.
