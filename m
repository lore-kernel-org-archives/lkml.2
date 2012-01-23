Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2AWC5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 21:57:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:57759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2AWC5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 21:57:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109737261"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "guenter.roeck@ericsson.com" <guenter.roeck@ericsson.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: RE: [PATCH v2] thermal: thermal_sys: Fix build warning
Thread-Topic: [PATCH v2] thermal: thermal_sys: Fix build warning
Thread-Index: AQHM2SVb15+Nh79S3kSIyB7H55/Qz5YZQrsg
Date: Mon, 23 Jan 2012 02:57:09 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5902CCD6@BGSMSX101.gar.corp.intel.com>
References: <1327249995-18682-1-git-send-email-festevam@gmail.com>
 <1327250761-7071-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1327250761-7071-1-git-send-email-festevam@gmail.com>
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

> From: Fabio Estevam [mailto:festevam@gmail.com]
> Sent: Sunday, January 22, 2012 10:16 PM
> To: linux-kernel@vger.kernel.org
> Cc: akpm@linux-foundation.org; guenter.roeck@ericsson.com; R, Durgadoss;
> khali@linux-fr.org; Fabio Estevam
> Subject: [PATCH v2] thermal: thermal_sys: Fix build warning
> 
> Fix the following build warning:
> 
> drivers/thermal/thermal_sys.c:63: warning: 'thermal_event_seqnum' defined but
> not used
> 
> ,which happens when CONFIG_NET is not set.
> 
> Move 'thermal_event_seqnum' definition inside the '#ifdef CONFIG_NET'
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Durgadoss R <durgadoss.r@intel.com>

[snip.]

Thanks,
Durga

