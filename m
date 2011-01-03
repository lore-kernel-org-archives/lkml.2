Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1ACPMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:12:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:59177 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab1ACPMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:12:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,267,1291622400"; 
   d="scan'208";a="369386508"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Mon, 3 Jan 2011 20:41:59 +0530
Subject: RE: Patch[1/2]X86:Adding_Notification_Support_to_therm_throt.c
Thread-Topic: Patch[1/2]X86:Adding_Notification_Support_to_therm_throt.c
Thread-Index: AcurV3ipr/P4F4nbREaELZwWwawkZgAABwkQ
Message-ID: <D6D887BA8C9DFF48B5233887EF04654105C125176B@bgsmsx502.gar.corp.intel.com>
References: <D6D887BA8C9DFF48B5233887EF04654105C1251710@bgsmsx502.gar.corp.intel.com>
 <20110103150328.GB25600@ericsson.com>
In-Reply-To: <20110103150328.GB25600@ericsson.com>
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

Hi Guenter,

> > From: Durgadoss R <durgadoss.r@intel.com>
> >
> > Date: Sun, 19 Dec 2010 22:42:45 +0530
> > Subject: [PATCH 1/2] X86:Adding_core_threshold_notification_to_therm_throt.c
> >
> > This patch adds code to therm_throt.c to notify core thermal threshold
> > events. These thresholds are supported by the IA32_THERM_INTERRUPT register.
> > The status/log for the same is monitored using the IA32_THERM_STATUS
> register.
> > The necessary #defines are in msr-index.h. A call back is added to mce.h, to
> > further notify the thermal stack, about the threshold events.
> >
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> >
> If this is just a resubmit, you might instead consider trying to figure out
> why none of the x86 maintainers replied. Documentation/Submit* might help,
> as well as comparing your set of patches with other (accepted) patches.
> 

This is a resubmission. I thought people might be on holidays..that's why
resubmitted today. Anyway, I shall try to figure out the reason. Thanks
for pointing it out Guenter..

Any comments on the hwmon patch 2/2 ?

Thanks,
Durga
