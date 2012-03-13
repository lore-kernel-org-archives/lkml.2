Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2CMEsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:48:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:27420 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2CMEse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118088087"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: RE: [PATCH 1/4] thermal: exynos: Add thermal interface support for
 linux thermal layer
Thread-Topic: [PATCH 1/4] thermal: exynos: Add thermal interface support for
 linux thermal layer
Thread-Index: AQHM+S325crfIhSomU2a5BXeXqw6HJZmfwxQgADUMQCAAGKN8A==
Date: Tue, 13 Mar 2012 04:48:23 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5904C758@BGSMSX101.gar.corp.intel.com>
References: <1330772767-16120-1-git-send-email-amit.kachhap@linaro.org>
	<1330772767-16120-2-git-send-email-amit.kachhap@linaro.org>
	<4D68720C2E767A4AA6A8796D42C8EB5904B13D@BGSMSX101.gar.corp.intel.com>
 <CAK44p23NwjPe3Ku0tfFXCQzi+2fdgEipFf+oCVKk99sC9qVMBA@mail.gmail.com>
In-Reply-To: <CAK44p23NwjPe3Ku0tfFXCQzi+2fdgEipFf+oCVKk99sC9qVMBA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

[snip.]

> >> +
> >> +     kobject_uevent(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE);
> >
> > Wouldn't it make more sense to pass the trip point id also as an 'env'
> > parameter ? This way, the user space can easily figure out which trip
> > point has been crossed.
> Its a good suggestion. I will check if some uevent property allows that.

The kobject_uevent_env(...) call allows that. The third argument takes a
char *envp[]. For example, We could pass "trip=0" to indicate the trip point.
I should have mentioned this in my previous reply itself..missed it..

Thanks,
Durga
