Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0IQBS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:18:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0IQBS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:18:26 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Sep 2010 06:46:49 +0530
Subject: RE: [PATCH 0/3] prepare ti-st to mv out of staging
Thread-Topic: [PATCH 0/3] prepare ti-st to mv out of staging
Thread-Index: ActV+0bOltwuCegkSTSN9zD7hxtToQACrquz
Message-ID: <19F8576C6E063C45BE387C64729E739404685FEA5E@dbde02.ent.ti.com>
References: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>,<20100916235829.GA26521@suse.de>
In-Reply-To: <20100916235829.GA26521@suse.de>
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


On Thu, Sep 16, 2010 at 08:49:29PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
>
> Greg,
>
> As suggested, the patch has been spilt to 3 patches:
> 1. corrects the data types
> 2. moves all headers to 1 file
> 3. sources are modified to make use of the newly created header file

>Almost.
>
>Never create a patch that breaks the build.  Your patch #2 did that,
>right?
>Care to merge number 2 and 3 together?

Yes, I did think of it, OK will send an update.

>thanks,
>greg k-h
