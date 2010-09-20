Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0ITQRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:17:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42784 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0ITQRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:17:05 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Sep 2010 21:46:43 +0530
Subject: RE: [PATCH 0/3] prepare ti-st to mv out of staging
Thread-Topic: [PATCH 0/3] prepare ti-st to mv out of staging
Thread-Index: ActV+0bOltwuCegkSTSN9zD7hxtToQACrquzALZHlMA=
Message-ID: <19F8576C6E063C45BE387C64729E73940468A15B71@dbde02.ent.ti.com>
References: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>,<20100916235829.GA26521@suse.de>
 <19F8576C6E063C45BE387C64729E739404685FEA5E@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404685FEA5E@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

 
> >
> > Greg,
> >
> > As suggested, the patch has been spilt to 3 patches:
> > 1. corrects the data types
> > 2. moves all headers to 1 file
> > 3. sources are modified to make use of the newly created header file
> 
> >Almost.
> >
> >Never create a patch that breaks the build.  Your patch #2 did that,
> >right?
> >Care to merge number 2 and 3 together?
> 
> Yes, I did think of it, OK will send an update.

I've sent across the patches, please review and merge.

> >thanks,
> >greg k-h
