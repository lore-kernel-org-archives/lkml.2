Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1CILKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:10:09 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36242 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab1CILKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:10:07 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 12:12:37 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110309111237.GA8987@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
 <20110309084222.GA3569@polaris.bitmath.org>
 <AANLkTin4KsPWRfFEEYXkjWdnEnXyiMyDGc6eEWFA_kWx@mail.gmail.com>
 <20110309093809.GA3980@polaris.bitmath.org>
 <AANLkTimQJpb41P-+xJX6BKCGWmNSF0rwGFwP7U97prA4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQJpb41P-+xJX6BKCGWmNSF0rwGFwP7U97prA4@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxHH6-0007xT-An.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PxHH6-0007xT-An b07b4173130e1ba99345262fc98f85a2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Yep, I've got three particular reasons:
> >> - 3M: there are two devices now, 1968 and 2256. The first one is a 10
> >> touches only, whereas the second one is a 60 touches.
> >
> > Right, so increasing the number of touches based on device information
> > seems like a good idea.
> 
> So the patch is useful.

Indeed. :-)

> >> - autodetection of multitouch devices. I have some patches on my tree
> >> (that we do not want to go upstream right now for some reasons) that
> >> allows us to plug any unknown multitouch devices and to let
> >> hid-multitouch handling it. As most of the devices are 2 touches only,
> >> and as the generic way to work with a multitouch devices is to iterate
> >> over all the slots, using 10 touches by default infers a lot of
> >> instructions that can be avoided.
> >
> > Right, so keeping the default number of touches per class seems like a
> > good idea.
> 
> That's the way the patch works: we can still manually provide the
> maxcontact per class, but if it's not needed (the device sends proper
> value), then we can skip it.

I misread the original patch, the maxcontacts are still there, so this
point is moot. Sorry about that. :-)

> >> - finally, it simplifies the writing of the new CLS (we just need to
> >> know how the device works to add the right quirks).
> >
> > Right, we always need to know how the device works. :-)
> 
> What I meant was the dynamic behavior of the device, not the static
> capabilities. ;)
> 
> Am I right if I take your reply as an Ack?

I will reply to the original patch with some comments.

Cheers,
Henrik
