Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab0HIAUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 20:20:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:58658 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab0HIAUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 20:20:48 -0400
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        Vadim Zaliva <lord@crocodile.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1281196050.4431.4.camel@jlt3.sipsolutions.net>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
	 <1268034117.3819.1.camel@jlt3.sipsolutions.net>
	 <36779F26-DB1B-46ED-8635-01B03E559B55@crocodile.org>
	 <20100310062227.GB2445@core.coreip.homeip.net>
	 <87k4o234lx.fsf@depni.sinp.msu.ru>
	 <1281196050.4431.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 10:20:23 +1000
Message-ID: <1281313223.2168.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > My device is 05ac:020e "fountain", actually generates *signed* values,
> > thus the patch completely breaks it.
> 
> I think Ben might have the same issue. I guess we need per-touchpad
> functions to read the data.

Yup, I confirm, same deal. This patch completely breaks it on my
powerbook (same USB ID)

Should we revert the commit for now ?

Cheers,
Ben.


