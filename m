Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1IZOKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:10:38 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:16567 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1IZOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:10:37 -0400
Date: Mon, 26 Sep 2011 16:06:55 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110926140655.GA16310@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
 <1314868526-13230-3-git-send-email-manohar.vanga@cern.ch>
 <4E609BAF.2020102@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E609BAF.2020102@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

Apologies for the delay, I was on vacation recently.

> I think we can probably merge vme_device_id and vme_dev.
> 
> Since we have a pointer to the vme_bridge, the bus number in vme_device_id is
> kinda superfluous.
> 
> The direction we are heading in makes the slot number far less important, in
> some ways it becomes more of an optional information field (in pre-vme64 racks
> we probably won't know which slot the device we are bound to is in anyway).
> Basically moving from a binding mechanism like PCI to a binding mechanism
> closer to ISA, which matches the (widely used, more historic subset) of
> capabilites of the VME bus. I think we can just move the slot number to
> vme_dev and do away with vme_device_id entirely.

I agree with this. I have, however, done this in a separate patch for clarity.
(I have resent this patch (in RESEND v6) unchanged so you can ack it there).

Thanks!

-- 
/manohar
