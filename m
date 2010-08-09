Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0HIDnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:43:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:39776 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0HIDnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:43:24 -0400
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vadim Zaliva <lord@crocodile.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <9D74DA20-E3C8-43BC-B529-82605F64637F@crocodile.org>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
	 <1268034117.3819.1.camel@jlt3.sipsolutions.net>
	 <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
	 <20100310062227.GB2445@core.coreip.homeip.net>
	 <87k4o234lx.fsf@depni.sinp.msu.ru>
	 <1281196050.4431.4.camel@jlt3.sipsolutions.net>
	 <1281313223.2168.46.camel@pasglop>
	 <9D74DA20-E3C8-43BC-B529-82605F64637F@crocodile.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 13:43:09 +1000
Message-ID: <1281325390.2168.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 18:24 -0700, Vadim Zaliva wrote:
> I have tested the patch on device I had       
> I will have an access to it to retest later thus week. We can wait for my
> test to try to identify how my PowerBook is different from yours. Or you
> can roll the patch back.

I'd rather roll the patch back for now. I'll send the revert as part of
the next powerpc update. We'll sort things out then.

Cheers,
Ben.

> 
> --
> Sent from my iPhone
> 
> On Aug 8, 2010, at 17:20, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> >>> My device is 05ac:020e "fountain", actually generates *signed* values,
> >>> thus the patch completely breaks it.
> >> 
> >> I think Ben might have the same issue. I guess we need per-touchpad
> >> functions to read the data.
> > 
> > Yup, I confirm, same deal. This patch completely breaks it on my
> > powerbook (same USB ID)
> > 
> > Should we revert the commit for now ?
> > 
> > Cheers,
> > Ben.
> > 


