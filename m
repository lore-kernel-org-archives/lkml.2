Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab0GIQ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:27:58 -0400
Received: from exprod6og111.obsmtp.com ([64.18.1.27]:50092 "HELO
	exprod6og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757935Ab0GIQ14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:27:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nic enumeration
Date: Fri, 9 Jul 2010 12:27:53 -0400
Message-ID: <D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
In-Reply-To: <82tyo9i0n2.fsf@mid.bfk.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nic enumeration
Thread-Index: AcsfNw/4ArRNoJy/S/60D9nOVwK+DgAPwn2Q
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com><20100708012120.GB11419@auslistsprd01.us.dell.com><D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com> <82tyo9i0n2.fsf@mid.bfk.de>
From: "Loke, Chetan" <Chetan.Loke@netscout.com>
To: "Florian Weimer" <fweimer@bfk.de>, <linux-net@vger.kernel.org>
Cc: "Matt Domsch" <Matt_Domsch@dell.com>,
       "Michael Di Domenico" <mdidomenico4@gmail.com>,
       <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>
X-OriginalArrivalTime: 09 Jul 2010 16:27:54.0568 (UTC) FILETIME=[AEE60C80:01CB1F83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Florian Weimer [mailto:fweimer@bfk.de]
> Sent: July 09, 2010 3:18 AM
> To: Loke, Chetan
> Cc: Matt Domsch; Michael Di Domenico; linux-net@vger.kernel.org;
linux-
> kernel@vger.kernel.org
> Subject: Re: nic enumeration
> 
> * Chetan Loke:
> 
> >> And on a system where you can use udev rules, the
> >> 70-persistent-net.rules file can be used to make them constant, by
> >> using the MAC address to force the names to be what you want.
> >>
> >
> > Ok, but can we achieve the renaming w/o a reboot?
> 
> "udev-trigger" or "udevadm trigger" works for renaming network
> interfaces.  The kernel has some restrictions on renaming interfaces
> which are in use, so this might not work in your case.
> 
> --

Ok, no renaming, I would like a reference. And symlink just doesn't work
w/ the udevadm trigger business. We've tried that already.

What needs to be changed in udev etc to create a soft link? Any place
where I should start digging and gotchas to lookout for?



> Florian Weimer                <fweimer@bfk.de>

Chetan Loke
