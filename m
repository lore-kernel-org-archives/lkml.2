Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0JGR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:58:01 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:53545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0JGR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:57:59 -0400
Subject: Re: RFC: btusb firmware load help
From: Johannes Berg <johannes@sipsolutions.net>
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Marcel Holtmann <holtmann@linux.intel.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <4CADF634.1030203@atheros.com>
References: <1286349552.6145.11.camel@aeonflux>
	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
	 <20101006173949.GG7070@tux>
	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
	 <1286389697.3655.401.camel@jlt3.sipsolutions.net>
	 ,<20101006183340.GI7070@tux>
	 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
	 <1286464555.20974.3.camel@jlt3.sipsolutions.net>
	 <4CADF634.1030203@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 19:57:53 +0200
Message-ID: <1286474273.20974.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 22:02 +0530, Bala Shanmugam wrote:

> AR3011 when plugged-in uses PID 3000 and control goes to DFU driver [ath3k].
> ath3k downloads the firmware to the device changing its PID to 3002.
> Now btusb gets the control and attaches the device to bluetooth core.
> 
> So blacklisting 3002 in btusb will create issues for AR3011 chipsets.
> In firmware if we change the PID from 3002 to 3003 as you suggested and 
> blacklist 3002 in btusb we can make both devices work.

Yeah, that still seems like the best approach, or maybe 3004 instead of
3003 if 3003 is already in use by a different chip, or whatever.

johannes

