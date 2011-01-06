Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1AFQGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:06:39 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50552 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab1AFQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:06:38 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Jan 2011 17:04:18 +0100
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/10] hid-multitouch: a first step towards multitouch
 unification
Message-ID: <20110106160418.GA1790@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <20110105174927.GB2146@polaris.bitmath.org>
 <AANLkTikCqufvOgYqqBZLjfmtSdsgyQV4L2HyvEP07+vf@mail.gmail.com>
 <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PasK5-0001ti-9q.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PasK5-0001ti-9q 1d80a385624d2f7ea71e6204f0315c36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The point is that currently we have users that want to have a proper
> > support for their device (PixCir, Cypress TrueTouch and GeneralTouch),
> > and it's a shame to ask them to wait for 3 more months.

That is understandable, but for the future, please bear in mind that
submitting patches in the merge window is the worst possible time
within that three-month period.

> > Maybe a solution would be to make what we can here during this merge
> > window to add support for at least the new devices. Then, in 2.6.39
> > and above, we could still migrate other devices, and eventually modify
> > some lines in the code.
> > 
> > Jiri, Dmitry, what do you think?
> 
> I still have to go through the patchset, my backlog has grown very badly 
> recently, sorry.
> 
> In case the patchset doesn't impose danger of regressions for already 
> existing devices, we could merge this new 'unified' driver only for newly 
> supported devices, and finish the unification in 2.6.39.

Sounds reasonable.

Thanks,
Henrik
