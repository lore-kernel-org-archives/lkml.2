Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1BKOCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:02:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:54305 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab1BKOCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:02:48 -0500
Date: Fri, 11 Feb 2011 15:02:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Alan Ott <alan@signal11.us>, Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Poole <mdpoole@troilus.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/4] Adding HID Feature Report Support to hidraw
In-Reply-To: <20110210181441.GB2173@joana>
Message-ID: <alpine.LNX.2.00.1102111501580.2160@pobox.suse.cz>
References: <1295337880-12452-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101191316230.26685@pobox.suse.cz> <20110210181441.GB2173@joana>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Gustavo F. Padovan wrote:

> > > This patch adds Feature Report support for USB and Bluetooth HID devices
> > > through hidraw.
> > > 
> > > The first two patches prepare the bluetooth side for the change.
> > > 	a. Make sure the hidp_session() thread is started before
> > > 	   device's probe() functions are called.
> > > 	b. Wait for ACK/NAK on sent reports, and return proper
> > > 	   error codes.
> > > The third patch is the hidraw core and USB changes.
> > > The fourth patch is the Bluetooth changes.
> > > 
> > > Thanks to Antonio Ospite and Bill Good for providing testing and feedback.
> > > 
> > > 
> > > Alan Ott (4):
> > >   bt hidp: Move hid_add_device() call to after hidp_session() has
> > >     started.
> > >   bt hidp: Wait for ACK on Sent Reports
> > >   HID: Add Support for Setting and Getting Feature Reports from hidraw
> > >   Bluetooth hidp: Add support for hidraw HIDIOCGFEATURE and
> > >     HIDIOCSFEATURE
> > > 
> > >  drivers/hid/hidraw.c          |  106 +++++++++++++++++++-
> > >  drivers/hid/usbhid/hid-core.c |   35 +++++++
> > >  include/linux/hid.h           |    3 +
> > >  include/linux/hidraw.h        |    3 +
> > >  net/bluetooth/hidp/core.c     |  214 ++++++++++++++++++++++++++++++++++++++---
> > >  net/bluetooth/hidp/hidp.h     |   15 +++
> > 
> > Before proceeding with these patches, I'd really like to have comment 
> > (ideally 'Acked-by') from Marcel on the net/bluetooth/hidp part, 
> > obviously.
> 
> I have tested it and it seems ok to me and to Marcel. For net/bluetooth/
> 
> Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

Awesome, thanks a lot everyone for having this sorted out finally!

I will be taking the patchset through my tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
