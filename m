Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1BHPy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:54:58 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:36508 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1BHPy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:54:57 -0500
X-Spam-Processed: srv201.gdsys.de, Tue, 08 Feb 2011 16:54:54 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Date: Tue, 8 Feb 2011 16:54:52 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE41@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-index: AcvHpdQarLmqmVeZTc+xvXlRCe1vGwAAc+4g
References: <1297170966-13101-1-git-send-email-eibach@gdsys.de> <20110208152815.GA13436@ericsson.com>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Guenter Roeck" <guenter.roeck@ericsson.com>
Cc: <linux-kernel@vger.kernel.org>, <khali@linux-fr.org>,
        <lm-sensors@lm-sensors.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110208155457Z
Subject: RE: [PATCH] hwmon: Consider LM64 temperature offset
Thread-Topic: RE: [PATCH] hwmon: Consider LM64 temperature offset
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.162; VDF: 7.11.2.101; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Guenter, 

> Chip id is already detected in lm63_detect. You don't need to 
> detect it again.
> The more common approach would be something along the line of
> 	data->kind = id->driver_data;
>     You would then use
> 	if (data->kind == lm64)
>     throughout the code. In addition to that, you could define
> 	data->kind = id->driver_data;
> 	if (data->kind == lm64)
> 		data->offset = 16000;
>     which would save you the repeated recalculation of offset 
> as mentioned before.

I don't understand, what structures "data" and "id" you are referring to
here and where the fields driver_data and kind come from. I remember to
have seen such in older kernels, but wasn't that replaced sometime ago?

Cheers
Dirk


