Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3AIGfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:35:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:37379 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AIGfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:35:50 -0500
Message-ID: <1357713345.1806.44.camel@aeonflux>
Subject: Re: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in
 alternate place
From: Marcel Holtmann <marcel@holtmann.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Bing Zhao <bzhao@marvell.com>, David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Jan 2013 22:35:45 -0800
In-Reply-To: <1357713088.1105.1.camel@unicorn>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
	 <1357689361-7969-2-git-send-email-lkundrak@v3.sk>
	 <1357698538.1806.43.camel@aeonflux>
	 <477F20668A386D41ADCC57781B1F70430D13FDB783@SC-VEXCH1.marvell.com>
	 <1357713088.1105.1.camel@unicorn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lubomir,

> > > > linux-firmware ships the sd8688* firmware images that are shared with
> > > > libertas_sdio WiFi driver under libertas/. libertas_sdio looks in both places
> > > > and so should we.
> > > >
> > > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > > ---
> > > >  drivers/bluetooth/btmrvl_sdio.c |   24 ++++++++++++++++++++++--
> > > >  drivers/bluetooth/btmrvl_sdio.h |    6 ++++--
> > > >  2 files changed, 26 insertions(+), 4 deletions(-)
> > > 
> > > NAK from me on this one. I do not want the driver to check two
> > > locations. That is what userspace can work around.
> > > 
> > > If we want to unify the location between the WiFi driver and the
> > > Bluetooth driver, I am fine with that, but seriously, just pick one over
> > > the other. I do not care which one.
> > 
> > The unified location is mrvl/ directory.
> > 
> > We can probably move SD8688 firmware & helper binaries to mrvl/ and have both drivers grab the images there?
> 
> That would break existing setups, wouldn't it?
> 
> I was under impression (commit 3d32a58b) that we care about
> compatibility here. Do we?

that is what symlinks are for.

Regards

Marcel


