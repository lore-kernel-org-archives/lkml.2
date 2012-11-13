Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2KMCEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:04:48 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:46831 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2KMCEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:04:46 -0500
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH v5] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH v5] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNvq8+4gF6/ke0DkSMmVgIflkkQJfmYW14//+PPgCAARdLEA==
Date: Tue, 13 Nov 2012 02:04:26 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F6236A@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121108150529.b16707c1c84e6fd862e58b6a@tw.synaptics.com>
 <20121109192604.GA16972@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F622A3@hkdcw-mail1.synaptics-inc.local>
 <20121112172056.GA1400@polaris.bitmath.org>
In-Reply-To: <20121112172056.GA1400@polaris.bitmath.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

> > > I am seeing _new_ irrelevant changes in this version... There is no
> > > need to revert to v3. Just remove the synaptics_rmi4_query_function()
> > > changes and other uneeded cruft from the v4 patch. No new changes,
> > > please, and make sure the final patch is tested.
> >
> > Those changes are intended to fix line over 80 characters in v3.
> > The code has been optimized and the logic does not change.
> 
> I would still prefer if the trivial non-functional changes were
> deferred to later patches. I realize that the change from 'TOUCHPAD'
> to 'TOUCHSCREEN' created some problems, but those changes were not
> called for in the first place. How about leaving those lines be for
> now, and then change to something more generic in a later patch? The
> code will obviously work equally well for both touchpad and
> touchscreen settings, so the defines could be better named anyways.
> 
> > Patch v5 has been verified with pandaboard.
> 
> Thank you.
> 
> Henrik

I see. As your suggestions in patch v5, I will resend patch containing only
functional changes.
Thanks for your advice.

Alexandra
