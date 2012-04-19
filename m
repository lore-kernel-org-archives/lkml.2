Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2DSMY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:24:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:13689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2DSMY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="90877330"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH] smb347_charger: Cleanup power supply registration code
 in probe
Thread-Topic: [PATCH] smb347_charger: Cleanup power supply registration code
 in probe
Thread-Index: AQHNHfujIFWokHjRXkGOFoOupWQHLJah+sPQ//+pVwCAAFy9cP//r/aAgABh2lA=
Date: Thu, 19 Apr 2012 12:24:52 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD10E625@BGSMSX102.gar.corp.intel.com>
References: <1334310292-22289-1-git-send-email-ramakrishna.pallala@intel.com>
	<20120419071104.GG18520@mwesterb-mobl.lan>
	<D854C92F57B1B347B57E531E78D05EAD10E4C0@BGSMSX102.gar.corp.intel.com>
	<CALp=xyOJpP=cioeNN4YqOYeDEt3Lz-fviVffmR_7AD5jf2Zc+g@mail.gmail.com>
	<D854C92F57B1B347B57E531E78D05EAD10E559@BGSMSX102.gar.corp.intel.com>
 <CALp=xyOhHSY-fSQfm8S30JgosjFqMFm4pj0o23s-A6JSPfzQKw@mail.gmail.com>
In-Reply-To: <CALp=xyOhHSY-fSQfm8S30JgosjFqMFm4pj0o23s-A6JSPfzQKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 19, 2012 at 2:30 PM, Pallala, Ramakrishna <ramakrishna.pallala@intel.com>
> wrote:
> >
> > what is gain and why user space need to see for usb online property
> > and get disappointed when platform has disabled USB charging( where user/user space
> has no idea about this).
> 
> Userspace doesn't have to know anything about how the platform is configured. It just
> reads standard and documented attributes and reacts on those.
> 
> > if usb charging is  not enabled just don't register. I think it's clean and make more
> sense to me.
> 
> I disagree but I'll let Anton to decide which is better and how it is supposed to work.
> 
> Btw, I think you should also check those places where
> power_supply_changed() is called for the supplies and make those conditional to what is
> registered.

I will resubmit the patch.

Thanks,
Ram
