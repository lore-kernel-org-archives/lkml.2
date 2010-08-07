Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab0HGAhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:37:10 -0400
Received: from ns1.cypress.com ([157.95.67.4]:39095 "EHLO ns1.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0HGAhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:37:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Date: Fri, 6 Aug 2010 17:32:31 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C4860A@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init submit
Thread-Index: Acs08wac7LUJHYW7Qfmn5zlVQF9oFwA0pUKQ
References: <Kevin McNeely <kev@cypress.com> <1281031924-3032-1-git-send-email-kev@cypress.com> <4C5B4404.6010602@euromail.se>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Fred" <fwk@ubuntu.linuxcertified.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>, "Ben Dooks" <ben-linux@fluff.org>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Todd Fischer" <todd.fischer@ridgerun.com>,
        "Arnaud Patard" <arnaud.patard@rtp-net.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Aug 2010 00:32:32.0907 (UTC) FILETIME=[068175B0:01CB35C8]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrick,

> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Thursday, August 05, 2010 4:07 PM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Fred; Samuel Ortiz;
Eric
> Miao; Ben Dooks; Simtec Linux Team; Todd Fischer; Arnaud Patard;
Sascha
> Hauer; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c: cyttsp i2c and spi touchscreen driver init
> submit
> 
> On 08/05/2010 08:12 PM, Kevin McNeely wrote:
> 
> > From: Fred <fwk@ubuntu.linuxcertified.com>
> >
> > This is a new touchscreen driver for the Cypress Semiconductor
> > cyttsp family of devices.  This updated driver is for both the i2c
> and spi
> > versions of the devices. The driver code consists of common core
code
> for
> > both i2c and spi driver.  This submission is in response to review
> comments
> > from the initial submission.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > ---
> 
> 
> General impression: There is a lot of useful code in here, but as
> already
> pointed out, well over half of it should not be part of the kernel
> driver.
> 
> Suggestion 1: Clean out the internal state code and use MT protocol B
> instead.
> 
> Suggestion 2: Cut out the single touch calculation, as already pointed
> out by
> Trilok. Why not submit it to the mtdev project instead? The problem is
> generic
> to all new MT drivers, so a common solution while waiting for full MT
> support in
> userspace could be useful.

I will remove the ST code and polling completely.

However, I would like to keep the MT Protocol A.  Our solution allows
The platform builder to select to use MT protocol B or not as part of 
platform_data in the board configuration. If it makes more sense,
I can reverse the code to default to protocol B and allow the platform
builder developer to select protocol A.

Thank you for the invitation to submit to the mtdev project.
I defer to Dmitry if I should make the next update into the mtdev
project.

Thank you for your review.
-kev

> 
> Thanks,
> Henrik

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

