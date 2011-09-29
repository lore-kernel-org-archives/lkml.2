Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1I2IOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:14:46 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:56137 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1I2IOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:14:43 -0400
X-SENDER-IP: [85.230.28.149]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai1ZAEAohE5V5hyVPGdsb2JhbABBiSueWwsBAQEBNzOBUwEBBAEyASMjBQsIAxguFCUKGhMbh10CuAwOhh1hBJkHjAo
X-IronPort-AV: E=Sophos;i="4.68,459,1312149600"; 
   d="scan'208";a="486677417"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 29 Sep 2011 10:19:56 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: =?iso-8859-1?Q?St=E9phane?= Chatty <chatty@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] autodetection of multitouch devices
Message-ID: <20110929081956.GA2282@polaris.bitmath.org>
References: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
 <alpine.LNX.2.00.1109261419330.13109@pobox.suse.cz>
 <20110926144635.GA6921@polaris.bitmath.org>
 <alpine.LNX.2.00.1109261644250.24692@pobox.suse.cz>
 <D3E37531-860E-415F-B2B9-58CEBB4E10A3@enac.fr>
 <CAN+gG=HWJ0tXvS8nbmv4u0CyB6tQo36xnhXE0xoRYjpdm2h2NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+gG=HWJ0tXvS8nbmv4u0CyB6tQo36xnhXE0xoRYjpdm2h2NA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:25:38PM +0200, Benjamin Tissoires wrote:
> On Wed, Sep 28, 2011 at 22:32, Stéphane Chatty <chatty@enac.fr> wrote:
> >
> > Le 26 sept. 2011 à 16:47, Jiri Kosina a écrit :
> >
> >> On Mon, 26 Sep 2011, Henrik Rydberg wrote:
> >>
> >>>>> These two patches finally enable the kernel to handle multitouch devices correctly.
> >>>>> If a device presents in its report descriptors the usage Contact ID, then it is considered as
> >>>>> a multitouch device and handled by hid-multitouch.
> >>>>
> >>>> Hi Banjamin,
> >>>>
> >>>> thanks a lot for working on this. I have now queued the patches in my
> >>>> tree.
> >>>
> >>> Hi Benjamin,
> >>>
> >>> Late as it seems, here are a couple of questions:
> >>>
> >>> 1. How was this tested? By removing all white-listed devices in
> >>> hid-multitouch.c to see if the usual suspects are still picked up?
> 
> Well, nearly all the devices that has been included since March passed
> the first patch (I had it in my queue since a long time).
> For now, only Stantum products are known to not work with this patch
> if we remove them from hid_have_special_driver.

I see, thanks.

> As for the blacklist problem, we also know that this is not very
> beautiful, but we are working on a better solution. For the moment, it
> just allows people to have their device working out of the box
> (crossing fingers).

It is great that you share a working solution for most cases, but it
does not look like mainline material yet, does it. A clean solution
should probably modify the driver selection mechanism on a deeper
level, or at least make use of the current whitelist.

Thanks,
Henrik
