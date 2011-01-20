Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1ATGzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:55:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:9776 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1ATGzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:55:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,349,1291622400"; 
   d="scan'208";a="649096086"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Thu, 20 Jan 2011 14:55:27 +0800
Subject: RE: [PATCH v2 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v2 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu4ajsrOkUt9FFqROis/vGzfx7gdAABHU9A
Message-ID: <5D8008F58939784290FAB48F54975198352A15C006@shsmsx502.ccr.corp.intel.com>
References: <20110113125727.GA20452@intel.com>
 <20110120032519.GA4827@void.printf.net>
 <5D8008F58939784290FAB48F54975198352A15BFC0@shsmsx502.ccr.corp.intel.com>
 <20110120062103.GB5732@void.printf.net>
In-Reply-To: <20110120062103.GB5732@void.printf.net>
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

Hi Chris,
> 
> On Thu, Jan 20, 2011 at 02:08:04PM +0800, Dong, Chuanxiao wrote:
> > > I think these should probably be printed in decimal instead of hex.
> 
> (Will assume you agree with this, let me know if not.)
Agree with this. Sorry for missing it.

> 
> > > Hm, this way the sysfs files will show up regardless of whether we have
> > > an eMMC device or an SD card, which is very confusing.  Can you not check
> > > whether enhanced_area_en == 1 before create these files?
> > >
> > SD card will not use this code when initializing. So I think these files only are
> created for eMMC card. If the eMMC card doesn't support enhanced area, can we
> use the same way like below scenario, exporting some value like -EINVAL to user?
> What do you think?
> 
> Oh, makes sense -- I agree, let's just use -EINVAL, and update the sysfs
> ABI doc to mention that.  Thanks!
Cool! I will fix these and then resubmit the new patch. :)

Thanks
Chuanxiao
