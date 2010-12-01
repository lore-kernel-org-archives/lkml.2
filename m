Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0LBAAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:00:24 -0500
Received: from ns2.cypress.com ([157.95.67.5]:59734 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0LBAAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:00:23 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
Date: Wed, 1 Dec 2010 15:59:46 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC0901231946@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
Thread-Index: AcuRZZgD1AP6S14iSdKZ9JCt854AAQATRy2Q
References: <Kevin McNeely <kev@cypress.com> <1289327120-2612-1-git-send-email-kev@cypress.com> <4CE163CC.1060202@euromail.se> <FB9C2CB29A07AB45B575A4E8D2AABC090119784D@labamba.mis.cypress.com> <4CF5F7BA.7070909@codeaurora.org> <4CF65DF8.2010806@euromail.se>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Henrik Rydberg" <rydberg@euromail.se>,
        "Trilok Soni" <tsoni@codeaurora.org>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Luotao Fu" <l.fu@pengutronix.de>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Dec 2010 23:59:47.0494 (UTC) FILETIME=[D55BFC60:01CB91B3]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

Cypress would like to submit as Protocol A now and provide a Protocol B
update later.

May I submit the updated Core Driver with the Protocol A only (tracking
ID's removed)? The updated Core Driver also includes other changes as
you recommended.

Thank you,
Kevin

> -----Original Message-----
> From: Henrik Rydberg [mailto:rydberg@euromail.se]
> Sent: Wednesday, December 01, 2010 6:39 AM
> To: Trilok Soni
> Cc: Kevin McNeely; Dmitry Torokhov; David Brown; Samuel Ortiz; Eric
> Miao; Simtec Linux Team; Luotao Fu; linux-input@vger.kernel.org;
linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
> 
> >>>
> 
> >>> Thanks for your submission. Please find comments on MT inline. On
a
> >>> general
> >>> note, it is strongly recommended that this driver be converted to
> the
> >>> MT slots
> >>> (type B) protocol.
> >>
> >> I will resubmit with Protocol A only at this time.  I will remove
> the
> >> Tracking ID's.
> >>
> >
> > Any comments on this?
> 
> 
> It is not optimal, but it is not wrong. If the plan is to support
> kernels 2.6.38
> and later, I strongly recommend using the type B protocol, as already
> stated.
> 
> Henrik

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

