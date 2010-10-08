Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0JHI1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:27:08 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48010 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab0JHI1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:27:06 -0400
Subject: RE: RFC: btusb firmware load help
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@Atheros.com>,
        Sree Durbha <Sree.Durbha@Atheros.com>
In-Reply-To: <1286474359.20974.13.camel@jlt3.sipsolutions.net>
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
	 <1286465072.6145.151.camel@aeonflux>
	 <1286474359.20974.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 10:26:58 +0200
Message-ID: <1286526418.6145.174.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> > I am still trying to figure out if this is one stage firmware loading or
> > a two stage firmware loading. This is all pretty unclear and nobody has
> > answered this clearly so far.
> 
> afaict, it's just one stage -- either it has sflash and you load ath3k
> firmware over it (the problematic 3002-before-loading case), or it
> doesn't have any firmware (and comes up with 3000) and you load the same
> ath3k firmware over it with a different mechanism, which currently
> announces itself as 3002 but can be changed.

sounds a lot better than what I understood initially. So essentially the
PID assigned for their different devices got screwed up. So that needs
to be fixed now.

Regards

Marcel


