Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2GWDIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 23:08:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:63591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2GWDIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 23:08:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171731141"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Jean Delvare <khali@linux-fr.org>,
        Devendra Naga <develkernel412222@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
CC: "Brown, Len" <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fengguang Wu <wfg@linux.intel.com>
Subject: RE: [PATCH] thermal: fix build error at thermal_sys.c
Thread-Topic: [PATCH] thermal: fix build error at thermal_sys.c
Thread-Index: AQHNZ+F6jcvK7NRhOEutcmNMsglvKZc0xc0AgAFqd0A=
Date: Mon, 23 Jul 2012 03:08:07 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59167CF8@BGSMSX101.gar.corp.intel.com>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
 <20120722125810.052ca19e@endymion.delvare>
In-Reply-To: <20120722125810.052ca19e@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: Sunday, July 22, 2012 4:28 PM
> To: Devendra Naga; Zhang, Rui
> Cc: Brown, Len; Andrew Morton; Joe Perches; linux-kernel@vger.kernel.org;
> Fengguang Wu; R, Durgadoss
> Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
> 
> On Sun, 22 Jul 2012 13:55:22 +0545, Devendra Naga wrote:
> > with the commit 67ff19 (Thermal: Make Thermal trip points writeable)
> > build error is introduced,
> >
> > the following was reported from Fengguang Wu,
> >
> > drivers/thermal/thermal_sys.c: In function 'create_trip_attrs':
> > drivers/thermal/thermal_sys.c:1216:3: error: 'count' undeclared (first use in this
> function)
> > drivers/thermal/thermal_sys.c:1216:3: note: each undeclared identifier is
> reported only once for each function it appears in
> >
> > link:
> > http://www.spinics.net/lists/linux-kernel-janitors/msg12174.html
> >
> > use the indx instead.
> 
> Thanks for the fix.
> 
> > Cc: Durgadoss R <durgadoss.r@intel.com>
> > Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> > ---
> >
> > This patch is build-tested only.
> 
> Something the original submitter apparently didn't do. Durga, can you
> please build-test all your commits from now on? I don't even understand
> how you managed to test your code if it did not build...
> 

I did build and functionality test also (as I had other patches to test on top of this),
on these patch sets; but wondering how it got introduced in this patch set..

Anyway, I will take care of these stupidities going forward.

Thanks,
Durga
