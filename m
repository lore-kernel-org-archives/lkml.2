Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab2CBQyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:54:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:57582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab2CBQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:54:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113884455"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>
CC: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>
Subject: RE: [lm-sensors] [PATCH 02/03] HWMON: HWMON driver for DA9052/53
 PMIC v3
Thread-Topic: [lm-sensors] [PATCH 02/03] HWMON: HWMON driver for DA9052/53
 PMIC v3
Thread-Index: AQHM+IKBxCM6yFjOIkmjMBf5lnWcdZZXNE5Q//+nu4CAAFzdwA==
Date: Fri, 2 Mar 2012 16:54:36 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59046B13@BGSMSX101.gar.corp.intel.com>
References: <1330698545.21817.31.camel@dhruva>
	 <4D68720C2E767A4AA6A8796D42C8EB59046AE9@BGSMSX101.gar.corp.intel.com>
 <1330707053.23014.279.camel@groeck-laptop>
In-Reply-To: <1330707053.23014.279.camel@groeck-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q22GsxPE019574

Hi Guenter,

> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> Sent: Friday, March 02, 2012 10:21 PM
> To: R, Durgadoss
> Cc: Ashish Jangam; randy.dunlap@oracle.com; linaro-dev@lists.linaro.org;
> sameo@linux.intel.com; linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org;
> dchen@diasemi.com
> Subject: RE: [lm-sensors] [PATCH 02/03] HWMON: HWMON driver for DA9052/53 PMIC
> v3
> 
> Hi Durga,
> 
> On Fri, 2012-03-02 at 11:44 -0500, R, Durgadoss wrote:
> > Hi,
> >
 
[snip..]

> > > +     sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
> > > +err_mem:
> >
> > I think you should do a kfree(hwmon) here.
> >
> 
> Not needed because devm_kzalloc() is used above.

Ok. Nice to know. Thank you :-)

Thanks,
Durga

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
