Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2KOC5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:57:04 -0500
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:51726 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167Ab2KOC5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:57:02 -0500
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
Thread-Index: AQHNwo8ZLxFuveX6UkK/mNwkyTKwrJfpGaGAgAEcNlA=
Date: Thu, 15 Nov 2012 02:56:45 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F6299E@hkdcw-mail1.synaptics-inc.local>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121113201212.8550fb074e1f7cce78f29d97@tw.synaptics.com>
 <20121113175309.GA3601@polaris.bitmath.org>
 <CC51EC7B5B7F984AA566DC102237848896F62894@hkdcw-mail1.synaptics-inc.local>
 <20121114180401.GC29131@core.coreip.homeip.net>
In-Reply-To: <20121114180401.GC29131@core.coreip.homeip.net>
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

> > As I know, currently there is no synaptics RMI4 touchscreen driver in the
> > main tree. In order to support our customers effectively, is it able to merge
> > staging ste_rmi4 driver into the main kernel.org tree? If it is accepted, should
> > I send a patch for this change?
> 
> I believe that we should keep ste_rmi4 in staging, not as reflection of
> its code quality, but rather because it is a temporary solution until
> full-fledged RMI4 driver is merged.
> 
> Please have Greg commit the patch that Henrik reviewed to staging and
> then work with Christopher Heiny group on getting the full featured
> driver into mainline.

Thank you for the prompt reply. The ste_rmi4 driver is actually not intended to be
a temporary solution for the full-fledged driver. We have requests from a number
of our customers and partners (Qualcomm, Samsung, Intel etc.) urging us to have
a driver available in the kernel mainline that is specific to touchscreen with simple
architecture and supporting our S3200 family of Touch Controllers and above. We
are committing resources to continue to maintain this driver and provide updates
to support future touch controller revisions from Synaptics.
It would be greatly appreciated if this driver can be considered for inclusion in the
kernel mainline.

Thank you.

Alexandra Chin
