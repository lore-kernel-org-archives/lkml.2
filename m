Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab2EOMnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:43:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:28448 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab2EOMnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143371783"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        "Tc, Jenny" <jenny.tc@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: RE: [lm-sensors] [PATCH] hwmon: Generic ADC support for hwmon
Thread-Topic: [lm-sensors] [PATCH] hwmon: Generic ADC support for hwmon
Thread-Index: AQHNMnjkS+3fNf6b0kSkKWKbLTmvzJbKZy2AgABjb3A=
Date: Tue, 15 May 2012 12:42:57 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59124E22@BGSMSX101.gar.corp.intel.com>
References: <1337092008-31263-1-git-send-email-jenny.tc@intel.com>
 <20120515121339.GA21600@ericsson.com>
In-Reply-To: <20120515121339.GA21600@ericsson.com>
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

Hi Guenter,

Thanks for a quick reply.

> On Tue, May 15, 2012 at 10:26:48AM -0400, Jenny TC wrote:
> > Currently drivers are using custom APIs to communicate with ADC driver.
> > So it make sense to have generic APIs to commnicate with ADC drivers.
> > This patch introduces generic APIs to communicate with ADC drivers.
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> 
> Hi Jenny,
> 
> Do you have a practical use case ?

We have some platform specific component drivers, thermal drivers,
battery drivers using this General purpose ADC in the platform.
That's why we thought of doing something like this.

> 
> Also, shouldn't those generic ADCs rather be supported through the IO
> subsystem ?
> After all, hwmon is all about hardware monitoring, not to provide generic ADC
> access.

In this case, can we try this in iio or mfd subsystem ?
Kindly advise.

Thanks,
Durga
