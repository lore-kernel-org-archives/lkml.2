Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab0LARGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:06:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38761 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab0LARF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:05:59 -0500
Date: Wed, 1 Dec 2010 17:05:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Francois Romieu <romieu@fr.zoreil.com>, Hayes Wang <hayeswang@realtek.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/r8169: Remove the firmware of RTL8111D
Message-ID: <20101201170552.GK8695@decadent.org.uk>
References: <1291180966-3124-1-git-send-email-hayeswang@realtek.com> <20101201080732.GA3234@electric-eye.fr.zoreil.com> <201012011736.59625.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012011736.59625.s.L-H@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 05:36:55PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Wednesday 01 December 2010, Francois Romieu wrote:
> > Hayes Wang <hayeswang@realtek.com> :
> > > Remove the firmware of RTL8111D from the kernel.
> > > The binary file of firmware would be moved to linux-firmware repository.
> > 
> > The driver can not simply go along when request_firmware fails. Though Ben's
> > code did not take care of it, the driver should imho propagate some return
> > code. Ben ?
> [...]
> 
> At least for RTL8111D-1 (rtl8168d_1_hw_phy_config(), phy_reg_init_2[])
> a missing firmware update doesn't seem to be fatal
> 	http://bugs.debian.org/561309#45
[...]

Yes.  Though it does clearly affect operation with some combinations of
cable and link partner.  There was a recent bug report on this, though
I can't find it now.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
