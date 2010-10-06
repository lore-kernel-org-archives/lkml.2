Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab0JFS2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:28:21 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab0JFS2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:28:19 -0400
Subject: Re: RFC: btusb firmware load help
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
        Sree Durbha <Sree.Durbha@atheros.com>
In-Reply-To: <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
References: <20100924230730.GB6566@tux> <1286266981.17473.33.camel@aeonflux>
	 <20101005192814.GB11831@tux> <1286308731.2588.13.camel@aeonflux>
	 <AANLkTimz7U52_qHaTutQDOFQde+GrWJRA0WpqY__FPgi@mail.gmail.com>
	 <1286349552.6145.11.camel@aeonflux>
	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
	 <20101006173949.GG7070@tux>
	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:28:17 +0200
Message-ID: <1286389697.3655.401.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 11:26 -0700, Luis R. Rodriguez wrote:

> > Good idea, I forgot about possible firmware changes :) Lets see if our
> > team can do that. Thanks for all the feedback.
> 
> Deepak a proof of concept test can involve simply hex-editing the
> ath3k-1.fw and replacing 0x3002 to 0x3003, then the above patch might
> work.

$ hd ath3k-1.fw
...
00000670  00 00 00 00 00 00 00 00  00 00 00 00 f3 0c 02 30  |...............0|
00000680  12 01 10 01 e0 01 01 40  f3 0c 02 30 01 00 00 00  |.......@...0....|
...

that looks a lot like the IDs right there, in little endian :-)

johannes

