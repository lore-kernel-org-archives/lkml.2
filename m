Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1AGR2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:28:34 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:46698 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447Ab1AGR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:28:33 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Jan 2011 18:27:07 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 03/10] hid-multitouch: support for PixCir-based panels
Message-ID: <20110107172707.GA6095@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <1294248468-19979-4-git-send-email-benjamin.tissoires@enac.fr>
 <20110106172528.GD1790@polaris.bitmath.org>
 <AANLkTimhk80b+jkqsNrxmFzSgmHX=_wdzbwE09NoFgV1@mail.gmail.com>
 <20110107122338.GB2312@polaris.bitmath.org>
 <AANLkTimYaZcvLyijtEm-iu+PzNXdozcNbFJQ6+PzD4vK@mail.gmail.com>
 <20110107155714.GA506@polaris.bitmath.org>
 <AANLkTimZ-VuvY8fEuPz7gzWVFvLHaJHG34gvkOuMMq2O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimZ-VuvY8fEuPz7gzWVFvLHaJHG34gvkOuMMq2O@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PbG5l-0002Pm-3F.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PbG5l-0002Pm-3F 3d6a2724e3a71eb7a7856669a9d7262c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But the mt_input_mapped function did not change - needs to change too.
> 
> I can not see any differences between mt_input_mapped and those found
> in 3m and egalax. Can you point me exactly what I should add please?

My bad - it seems your tree does contain the right function. Another
reason to have the patches in mail. :-)

> >> - The Egalax problem: I am pretty sure that Stéphane took this driver
> >> into account when writing the original patch. BTW I propose to
> >> postpone the problem for 2.6.39.
> >
> > This driver is aiming at engulfing a larger set of drivers, and as
> > such, should be prepared sensibly, IMO. Rushing things will only cause
> > us grief further down the road.
> >
> 
> So, have you got any clue (or even better, can you test a solution)
> for those devices?

Yes I can, but I will not be available the coming couple of days, so
the timing is a bit off. I agree with you that we do not need to solve
every issue right now, but I know for a fact that the newer DWAV
firmware has no touch frame indication, and does not assume the
not-seen-means-up behavior. Perhaps it is enough to just add the
quirks field to the class, define one or two quirks currently in use,
and leave the rest for later. Sounds reasonable?

Thanks,
Henrik
