Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2JFV2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 17:28:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2JFV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 17:28:52 -0400
Date: Sat, 6 Oct 2012 23:28:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-15?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        =?ISO-2022-JP?Q?=1B$BN-2E=3DY=1B=28J?= <scott.liu@emc.com.tw>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, USB list <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification 
 implementation
In-Reply-To: <alpine.LNX.2.00.1210062314110.27782@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1210062326150.27782@pobox.suse.cz>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com> <20121006220421.47f5fd56@endymion.delvare> <6F756B9E-DC87-4EF6-BB09-8A69A5F8C999@enac.fr> <20121006231111.6350c014@endymion.delvare>
 <alpine.LNX.2.00.1210062314110.27782@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012, Jiri Kosina wrote:

> > My vote is a clear 3. It took me a few years to kick all users (as
> > opposed to implementers) of i2c from drivers/i2c and finding them a
> > proper home, I'm not going to accept new intruders. Grouping drivers
> > according to what they implement makes it a lot easier to share code
> > and ideas between related drivers. If you want to convince yourself,
> > just imagine the mess it would be if all drivers for PCI devices lived
> > under drivers/pci.
> 
> This is more or less consistent with my original opinion when I was 
> refactoring the HID layer out of the individual drivers a few years ago.
> 
> But Marcel objected that he wants to keep all the bluetooth-related 
> drivers under net/bluetooth, and I didn't really want to push hard against 
> this, because I don't have really super-strong personal preference either 
> way.
> 
> But we definitely can use this oportunity to bring this up for discussion 
> again.

Basically, to me this all boils down to the question -- what is more 
important: low-level transport being used, or the general function of the 
device?

To me, it's the latter, and as such, everything would belong under 
drivers/hid.

On the other hand, I believe the Marcel will be arguing the bluetooth 
devices are actually network devices, and he has got a point as well (even 
though I personally consider bluetooth keyboard to be much more HID device 
than network device).

-- 
Jiri Kosina
SUSE Labs
