Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2BXIkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:40:49 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:52385 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab2BXIks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:40:48 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Feb 2012 03:40:47 EST
X-Spam-Processed: srv201.gdsys.de, Fri, 24 Feb 2012 09:31:48 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Subject: Commit 529febe breaks usb on Freescale P1022
Importance: normal
Date: Fri, 24 Feb 2012 09:31:49 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BF89@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Commit 529febe breaks usb on Freescale P1022
thread-index: Aczyzrz7Op4ygo1gSgGaOHDIktPOMw==
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: <Shengzhou.Liu@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <stern@rowland.harvard.edu>
X-SafeGuard_MailGateway: Version: 5.60.3.11066 SGMG Date: 20120224083150Z
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.10.8; VDF: 7.11.23.240; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This commit introduces a check for the USB PHY clock.
Problem is that CTRL_PHY_CLK_VALID bit seems not to be present on all
Freescale ehci implementations, at least P1022 does not have it. So this
check always fails and the driver never gets loaded. 

Cheers
Dirk
--------------------------------------------------------------------------
Guntermann & Drunck GmbH Systementwicklung 
Dortmunder Str. 4a 
D-57234 Wilnsdorf - Germany 
Tel: +49 (0) 27 39 / 89 01 - 100  Fax: +49 (0) 27 39 / 89 01 - 120 
E-Mail: mailto:sales@gdsys.de Web: http://www.gdsys.de
--------------------------------------------------------------------------
Geschaeftsfuehrer: 
Udo Guntermann - Martin Drunck - Reiner Ruelmann
HRB 2884, Amtsgericht Siegen - WEEE-Reg.-Nr. DE30763240
USt.-Id.-Nr. DE 126575222 - Steuer-Nr. 342 / 5835 / 1041
--------------------------------------------------------------------------
DQS-zertifiziert nach ISO 9001:2000
--------------------------------------------------------------------------


