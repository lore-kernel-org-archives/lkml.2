Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1BXScl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:32:41 -0500
Received: from ns2.cypress.com ([157.95.67.5]:52891 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab1BXScj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:32:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [v4 1/3] 1/3 Touchscreen: Cypress TTSP G3 Core Driver
Date: Thu, 24 Feb 2011 10:31:19 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC0901629825@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [v4 1/3] 1/3 Touchscreen: Cypress TTSP G3 Core Driver
Thread-Index: Acus/t93V77wsWGtT9CB9CajFsNChQnUayig
References: <kev@cypress.com> <1294188847-24728-1-git-send-email-kev@cypress.com> <20110105085942.GA23321@polaris.bitmath.org> <FB9C2CB29A07AB45B575A4E8D2AABC09014003B8@labamba.mis.cypress.com> <20110105173403.GA2146@polaris.bitmath.org>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Alan Cox" <alan@linux.intel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Feb 2011 18:32:09.0270 (UTC) FILETIME=[2541CD60:01CBD451]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

I have been testing with Android based systems.
What system configurations are good for testing the slot handling in
Protocol B?

Thanks and best regards,
Kevin


> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Wednesday, January 05, 2011 9:34 AM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Samuel Ortiz; Eric
Miao;
> Mike Frysinger; Alan Cox; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [v4 1/3] 1/3 Touchscreen: Cypress TTSP G3 Core Driver
> 
> Hi Kevin,
> 
> > Hi Henrik,
> >
> > Thank you for the code modifications.
> > The mods work for both I2C and SPI builds.
> 
> Great!
> 
> > Can you post your modified patch?
> 
> There might be more comments to v4, so if there is a v5, you can just
> send it then. Otherwise, we have what we need.
> 
> Thanks,
> Henrik
