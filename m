Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab2CUSGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:06:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52988 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758943Ab2CUSGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:06:07 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Robert Lee <rob.lee@linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: davinci: Fix for cpuidle consolidation changes
Thread-Topic: [PATCH] ARM: davinci: Fix for cpuidle consolidation changes
Thread-Index: AQHNB4Ka3xiqAO2EBUWunPzTMkAf1pZ1Cy+w
Date: Wed, 21 Mar 2012 18:05:54 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B631800C76@DBDE01.ent.ti.com>
References: <1332348505-28780-1-git-send-email-rob.lee@linaro.org>
In-Reply-To: <1332348505-28780-1-git-send-email-rob.lee@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 22:18:25, Robert Lee wrote:
> The recent cpuidle consolidation changes erroneously omitted one
> critical line of code.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>

Tested this on a DA850 EVM.

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

