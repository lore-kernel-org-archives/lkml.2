Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777Ab2EOQ3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:29:13 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4608 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965661Ab2EOQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:29:11 -0400
Message-ID: <1337099344.13455.9.camel@x61.thuisdomein>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 18:29:04 +0200
In-Reply-To: <20120515153539.GA25206@kroah.com>
References: <1336491453.1933.67.camel@x61.thuisdomein>
	 <Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
	 <20120515153539.GA25206@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 15 May 2012 16:29:05.0026 (UTC) FILETIME=[D8241620:01CD32B7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 08:35 -0700, Greg Kroah-Hartman wrote:
> > > Of course, an easy way out would be to downgrade both the "Asking for
> > > cache data failed" and the "No Caching mode page present" errors to
> > > notices. But the SCSI people might disagree with that approach.
> > 
> > Well, let's see what they say.
> 
> What ever happened here, are these 3 patches acceptable, or do they need
> to be reworked or something else?

Nothing happened after Alan's message.

So, currently only the first patch was acceptable (to Alan, that is, but
it touched the SCSI code).

At least, I haven't seen a reply from the SCSI people. Perhaps the best
thing to do is to submit a series of one or two trivial patches that
just downgrade the errors involved to notices. That should lead to
feedback by the SCSI people.


Paul Bolle

