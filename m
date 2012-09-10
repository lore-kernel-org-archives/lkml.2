Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2IJXH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:07:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:25829 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab2IJXHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:07:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="191104304"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Thread-Topic: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Thread-Index: AQHNj3+8NrsaPyLWXkq5y7fK1RYEOJeEMngA
Date: Mon, 10 Sep 2012 23:07:08 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A17BFF0@SHSMSX101.ccr.corp.intel.com>
References: <1347009599.1119.9.camel@cliu38-desktop-build>
 <20120910180857.GA12223@kroah.com>
In-Reply-To: <20120910180857.GA12223@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> >  drivers/usb/core/hcd.c       |   15 ---------------
> >  drivers/usb/host/ehci-ls1x.c |    2 +-
> >  drivers/usb/host/ohci-xls.c  |    2 +-
> >  3 files changed, 2 insertions(+), 17 deletions(-)
> 
> This fails to apply to my usb-next branch for some odd reason, please
> refresh it and resend.
> 
> thanks,
> 
> greg k-h

Has resent, refresh the code base and sent with evolution client, wish it is OK, thanks.
