Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KLRnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:43:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39299 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLRnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:43:39 -0500
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm@lists.arm.linux.org.uk" <linux-arm@lists.arm.linux.org.uk>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Fri, 12 Nov 2010 23:13:17 +0530
Subject: RE: [PATCHv5] OMAP: Serial: Define OMAP uart MDR1 reg and remove
 magic numbers
Thread-Topic: [PATCHv5] OMAP: Serial: Define OMAP uart MDR1 reg and remove
 magic numbers
Thread-Index: AcuCkBKaE9773N3NR++foGdE7fWKZwAAKaIg
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F12A@dbde02.ent.ti.com>
References: <1289568557-9727-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <20101112173531.GD9264@atomide.com>
In-Reply-To: <20101112173531.GD9264@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Tony Lindgren
> Sent: Friday, November 12, 2010 11:06 PM
> To: Emeltchenko Andrei
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; 
> linux-arm@lists.arm.linux.org.uk; linux-serial@vger.kernel.org
> Subject: Re: [PATCHv5] OMAP: Serial: Define OMAP uart MDR1 
> reg and remove magic numbers
> 
> * Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com> 
> [101112 05:22]:
> > From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
> > 
> > Define MDR1 register serial definitions used in serial and
> > bluetooth drivers.
> > Change magic number to ones defined in serial_reg for omap1/2
> > serial driver.
> > Remove redefined MDR1 register definitions in omap-serial driver.
> 
> Thanks, queueing this for 2.6.38 and adding the ack from Greg from
> the previous version.
> 

Acked-by: G, Manjunath Kondaiah <manjugk@ti.com>
Acked-by: Govindraj.R <govindraj.raja@ti.com>

-Manjunath