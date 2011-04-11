Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1DKSNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:13:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53594 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab1DKSNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:13:12 -0400
Date: Mon, 11 Apr 2011 19:13:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800pci: rt2800usb: Firmware update
Message-ID: <20110411181303.GD2268@decadent.org.uk>
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net>
 <4DA33F3A.6090707@gmail.com>
 <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimJCNpTqn-uQjRLHTyGjHxd+BpJ4Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.i.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 07:57:15PM +0200, Ivo Van Doorn wrote:
> >> From: Shiang Tu<shiang_tu@ralinktech.com>
> >>
> >> Update firmware for rt2800pci to Version 34 and firmware for rt2800usb to
> >> Version 29.
> >>
> >> Signed-off-by: Shiang Tu<shiang_tu@ralinktech.com>
> >> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> >> ---
> >>  WHENCE     |    8 ++++----
> >>  rt2860.bin |  Bin 8192 ->  8192 bytes
> >>  rt2870.bin |  Bin 4096 ->  8192 bytes
> >>  3 files changed, 4 insertions(+), 4 deletions(-)
> >
> > links to rt3070.bin rt3071.bin rt3090.bin ???
> 
> What do you mean? Those files should be deleted from the linux-firmware
> package. There is no need to keep them around, as with the removal of
> the staging drivers, the last users of those files are gone.
 
Stop repeating this nonsense, Ivo.  If the firmware has been bundled in
the Linux tree, that would be correct.  For linux-firmware the policy is
different.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
