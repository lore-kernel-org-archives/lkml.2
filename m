Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2BXKLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:11:51 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:60037 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab2BXKLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:11:49 -0500
X-Spam-Processed: srv201.gdsys.de, Fri, 24 Feb 2012 11:11:45 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Importance: normal
Subject: Re: Commit 529febe breaks usb on Freescale P1022
Date: Fri, 24 Feb 2012 11:11:46 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BF8C@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Commit 529febe breaks usb on Freescale P1022
thread-index: Aczy29vlChUH60biR2eFSP/bYwlZBwAAI4WA
References: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de> <20120224100513.GH17178@legolas.emea.dhcp.ti.com>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: <balbi@ti.com>
Cc: <Shengzhou.Liu@freescale.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <stern@rowland.harvard.edu>
X-SafeGuard_MailGateway: Version: 5.60.3.11066 SGMG Date: 20120224101147Z
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Class: urn:content-classes:message
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.10.8; VDF: 7.11.23.246; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> > This commit introduces a check for the USB PHY clock.
> > Problem is that CTRL_PHY_CLK_VALID bit seems not to be 
> present on all 
> > Freescale ehci implementations, at least P1022 does not have it. So 
> > this check always fails and the driver never gets loaded.
> 
> hmm, you would need a revision check on that function then.

Since I have no idea which Freescale platforms provide this bit and
which platforms don't, I suggest withdrawing this commit and do some
investigation on Freescales side to do this properly.

Cheers
Dirk


