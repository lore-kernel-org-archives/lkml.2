Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1CCHxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:53:08 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:46595 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1CCHxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:53:07 -0500
X-Spam-Processed: srv201.gdsys.de, Thu, 03 Mar 2011 08:53:03 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Subject: RE: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
Date: Thu, 3 Mar 2011 08:53:01 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE6C@SRV101.gdsys.de>
Importance: normal
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
thread-index: AcvZA1I8qnw9ALx8Rk2JeSRsQg3aFwAdDDrg
References: <20110302185718.3c0e06dc@endymion.delvare>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, <guenter.roeck@ericsson.com>,
        <lm-sensors@lm-sensors.org>, <rdunlap@xenotime.net>,
        <linux-doc@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110303075305Z
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.178; VDF: 7.11.4.47; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Patch applied. Two things I'd still like to comment on:

Ahh, good news :)

> Besides this, there is still more dynamic attribute handling 
> than I expected. It looks OK, but I'll propose a patch making 
> it more static.
> You'll tell me what you think.

I put the attributes in a group because I thought handling single
attributes is clumsy and error prone.
Anyway I am looking forward to your proposal.
Will this be a v5 or a separate patch?

> --
> Jean Delvare

Chhers
Dirk
------------------------------------------------------------------------------------------------
Messe-Highlights 2011. Wir freuen uns auf Ihren Besuch.                                         

CeBIT 2011 
In Hannover - 01.03. bis 05.03.2011 - Halle 12, Stand C50

ATC Global 2011 
Amsterdam - 08.03. bis 10.03.2011 - Halle 9, Stand R404
------------------------------------------------------------------------------------------------
Guntermann & Drunck GmbH Systementwicklung 
Dortmunder Str. 4a 
D-57234 Wilnsdorf - Germany 
Tel: +49 (0) 27 39 / 89 01 - 100  Fax: +49 (0) 27 39 / 89 01 - 120 
E-Mail: sales@gdsys.de - Web: www.gdsys.de
------------------------------------------------------------------------------------------------
Geschaftsfuhrer: 
Udo Guntermann - Martin Drunck - Reiner Ruelmann - Klaus Tocke
HRB 2884, Amtsgericht Siegen - WEEE-Reg.-Nr. DE30763240
USt.-Id.-Nr. DE 126575222 - Steuer-Nr. 342 / 5835 / 1041
------------------------------------------------------------------------------------------------
DQS-zertifiziert nach ISO 9001:2000
------------------------------------------------------------------------------------------------


