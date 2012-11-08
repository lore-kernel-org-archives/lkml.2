Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2KHEBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:01:52 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:58237 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2KHEBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:01:50 -0500
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
Subject: RE: [PATCH v4] staging: ste_rmi4: Convert to Type-B support
Thread-Topic: [PATCH v4] staging: ste_rmi4: Convert to Type-B support
Thread-Index: AQHNvSIR3LY4U9ZxvUK/gDGKAji5K5ffRcgw
Date: Thu, 8 Nov 2012 04:01:32 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F61184@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121107134934.b37e923588f4a24af146a93b@tw.synaptics.com>
 <20121107195708.GA3754@polaris.bitmath.org>
In-Reply-To: <20121107195708.GA3754@polaris.bitmath.org>
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

Hi Henrik.

> > Convert to MT-B because Synaptics touch devices are capable of tracking
> > identifiable fingers.
> >
> > Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> > ---
> > Changes from v4:
> >         - Incorporated Henrik's review comments
> >           *split function synpatics_rmi4_touchscreen_report
> >           *split function synaptics_rmi4_i2c_query_device
> 
> Thanks for the changes. The patch looks cleaner, but also much larger,
> containing many changes irrelevant to the commit message (and to what
> has hitherto been reviewed). Please resend a minimum patch, there is
> plenty of room for additional patches after this one. :-)
> 
> Thanks,
> Henrik

Appreciate your review!
I think there is not much of change in patch v4, but git diff tool makes it 
look larger.
Since patch v4 is considered too large, let me resubmit a minimum patch,
and update changes of v4 in future patch.
Thank you for your advice.

Alexandra
