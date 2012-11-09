Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab2KIIVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:21:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:11565 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab2KIIVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:21:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,744,1344236400"; 
   d="scan'208";a="166288047"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ming Lei <ming.lei@canonical.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] firmware loader: Fix the concurrent request_firmware()
 race for kref_get/put
Thread-Topic: [PATCH] firmware loader: Fix the concurrent request_firmware()
 race for kref_get/put
Thread-Index: AQHNvlKF44a01VzHaEKMQV23uQNZjZfhKOPg
Date: Fri, 9 Nov 2012 08:21:27 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1C1F20@SHSMSX101.ccr.corp.intel.com>
References: <1352464110.15558.1620.camel@cliu38-desktop-build>
 <CACVXFVN7RVzQB5X8h=XazQm+vwwwKzGyAm5jNhiYbdqTJeR_TQ@mail.gmail.com>
In-Reply-To: <CACVXFVN7RVzQB5X8h=XazQm+vwwwKzGyAm5jNhiYbdqTJeR_TQ@mail.gmail.com>
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

> $./scripts/checkpatch.pl
> ERROR: space required before the open parenthesis '('
> #97: FILE: drivers/base/firmware_class.c:267:
> +	if(!kref_put(&buf->ref, __fw_free_buf))
> 
> 
> > +               spin_unlock(&fwc->lock);
> >  }
> >
> >  /* direct firmware loading support */
> 
> After fixing the patch style error, you can add my ack:
> 
Thanks your pointing out, fix it soon.
