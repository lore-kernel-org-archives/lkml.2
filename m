Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0HDQmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:42:49 -0400
Received: from ns1.cypress.com ([157.95.67.4]:40900 "EHLO ns1.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab0HDQmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:42:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Date: Wed, 4 Aug 2010 09:38:52 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C48155@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Thread-Index: AcsiV7RIBGepz/szTLiT7Dv+DyWpbgRmr2eQ
References: <Kevin McNeely <kev@cypress.com> <1278968210-6827-1-git-send-email-kev@cypress.com> <4C3C0C36.5080608@euromail.se>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Fred" <fwk@ubuntu.linuxcertified.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Arnaud Patard" <arnaud.patard@rtp-net.org>,
        "Antonio Ospite" <ospite@studenti.unina.it>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Aug 2010 16:38:53.0589 (UTC) FILETIME=[86722C50:01CB33F3]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Monday, July 12, 2010 11:48 PM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Fred; Samuel Ortiz;
Eric
> Miao; Mark Brown; Simtec Linux Team; Arnaud Patard; Antonio Ospite;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
> 
> Kevin McNeely wrote:
> > From: Fred <fwk@ubuntu.linuxcertified.com>
> >
> > This is a new touchscreen driver for the Cypress Semiconductor
> > cyttsp family of devices.  This driver is for the i2c version
> > of cyttsp parts.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > ---
> 
> This driver contains too much code. I am wondering if the device
> actually
> supports tracking id, or whether it is emulated in the driver code? If
> tracking
> is not well supported in hardware, then please use MT protocol A and
> remove the
> usage of ABS_MT_TRACKING_ID and the logic around it. If tracking is
> indeed well
> supported in the hardware, then please use MT protocol B.
> 
> Thanks,
> Henrik

I have a new code set that has been refactored and easier to follow.
The driver supports both Protocol A and Protocol B.
The Cypress TTSP parts have well supported Tracking ID's, so the driver
provides protocol B reporting option.
The driver also handles reporting without the Tracking ID's for Protocol
A option.
A user selects which option in the board configuration file.

Thank you Henrik for your review.



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

