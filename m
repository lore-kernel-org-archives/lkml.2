Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1GEFhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 01:37:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:55157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1GEFhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 01:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,477,1304319600"; 
   d="scan'208";a="21574350"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "linux-x86_64@vger.kernel.org" <linux-x86_64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "R, Durgadoss" <durgadoss.r@intel.com>
Date: Tue, 5 Jul 2011 11:06:42 +0530
Subject: CPU clock throttled prints..
Thread-Topic: CPU clock throttled prints..
Thread-Index: Acw6IWmPLAxAez/AQR+k9kKUqDQSdgAsnE4A
Message-ID: <D6D887BA8C9DFF48B5233887EF04654109E855E9B4@bgsmsx502.gar.corp.intel.com>
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

Hi All,

I am getting these prints in my Atom based device, running 2.6.35 kernel.

[  350.084005] CPU0: Temperature above threshold, cpu clock throttled (total
events = 26)
[  350.084029] CPU1: Temperature above threshold, cpu clock throttled (total
events = 26)
[  350.085293] CPU0: Temperature/speed normal
[  350.085311] CPU1: Temperature/speed normal

Seems like these are from therm_throt.c and the flow for this,
Starts from smp_thermal_interrupt(...) method.

Can somebody tell me when this method gets called ?
Also, does this actually throttle the CPU ?

Thanks,
Durga
