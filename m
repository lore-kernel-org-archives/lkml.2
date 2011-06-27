Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1F0QlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:41:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:13391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1F0QlC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:41:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,433,1304319600"; 
   d="scan'208";a="18875205"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Date: Mon, 27 Jun 2011 22:10:44 +0530
Subject: RE: [lm-sensors] coretemp: Support for Intel Atom E6XX CPU
	(TunnelCreek)?
Thread-Topic: [lm-sensors] coretemp: Support for Intel Atom E6XX CPU
	(TunnelCreek)?
Thread-Index: Acw05RixIjnOFjKaTBme1Y9yG2QpkAAA4FiA
Message-ID: <D6D887BA8C9DFF48B5233887EF04654109E84A62C0@bgsmsx502.gar.corp.intel.com>
References: <201106271220.51953.alexander.stein@systec-electronic.com>
	<20110627164108.777c2e28@endymion.delvare>
 <1309191054.8271.636.camel@groeck-laptop>
In-Reply-To: <1309191054.8271.636.camel@groeck-laptop>
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

> I thought about replacing the manual TjMax detection code with code
> using the model string to take care of problems like this - essentially
> by providing a table with entries { model string, Tjmax } for each CPU
> with Tjmax other than 100 degrees C. This way we could get rid of some
> of the odd code we have today. Would that make sense ?

I completely agree with you here.
This way, a lot of code in get_tjmax will be reduced, by just
a search through some array.
 
Thanks,
Durga

