Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2B1NLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:11:54 -0500
Received: from mx0.aculab.com ([213.249.233.131]:47469 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755950Ab2B1NLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:11:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] ARM: LPC32xx: Ethernet driver
Date: Tue, 28 Feb 2012 13:11:06 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com>
In-Reply-To: <4F4CD1D8.8030102@antcom.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] ARM: LPC32xx: Ethernet driver
Thread-Index: Acz2GgYbgXipltaeS2K6nmrDiWrHNwAAEpfg
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Roland Stigge" <stigge@antcom.de>, <baruch@tkos.co.il>
Cc: <alexander.h.duyck@intel.com>, <ian.campbell@citrix.com>,
        <netdev@vger.kernel.org>, <eilong@broadcom.com>,
        "Kevin Wells" <kevin.wells@nxp.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>, <jeffrey.t.kirsher@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 28 Feb 2012 13:11:07.0861 (UTC) FILETIME=[6EFDC850:01CCF61A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Thanks for the note! I actually found out that in many cases, the
> bootloader already initialized the hardware with the target 
> MAC address so we can use this one.
> 
> For the case that it _isn't_ initialized already, is it the right
thing
> to use a hard coded default MAC address to be replaced by the final
one
> in userspace? (I found such examples in some current micrel/ and amd/
drivers.)

Using a fixed address is a very bad idea ...

	David


