Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2KPJCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:02:39 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:24965 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2KPJCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:02:36 -0500
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [RFC] staging: ste_rmi4: merge into the main kernel tree
Thread-Topic: [RFC] staging: ste_rmi4: merge into the main kernel tree
Thread-Index: AQHNwo8ZLxFuveX6UkK/mNwkyTKwrJfpGaGAgAEcNlD//7gdgIACP7jQ
Date: Fri, 16 Nov 2012 09:02:30 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F62D19@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121113201212.8550fb074e1f7cce78f29d97@tw.synaptics.com>
 <20121113175309.GA3601@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F62894@hkdcw-mail1.synaptics-inc.local>
 <20121114180401.GC29131@core.coreip.homeip.net>
 <CC51EC7B5B7F984AA566DC102237848896F6299E@hkdcw-mail1.synaptics-inc.local>
 <20121115064359.GA17551@core.coreip.homeip.net>
In-Reply-To: <20121115064359.GA17551@core.coreip.homeip.net>
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

Hi Dmitry,

> > > Please have Greg commit the patch that Henrik reviewed to staging and
> > > then work with Christopher Heiny group on getting the full featured
> > > driver into mainline.

Thanks for your reminding, final patch has been re-sent to staging
maintainer.

> In this case you need to enumerate the benefits of this driver over
> unified driver and show why the unified driver can't be fixed.
> 
> Currently the driver is in mainline (even though the directory is
> staging) and nobody will remove it until another driver is fully
> functional and ready for prime time. But once this happens I do not see
> the benefits of maintaining 2 drivers for the same hardware.

I see. Given that the driver will remain in mainline before generic driver
is ready, currently I will continue to maintain the driver in staging.

Appreciate your response.

Alexandra
