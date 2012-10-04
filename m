Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2JDFwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 01:52:49 -0400
Received: from tw-mx2.synaptics.com.tw ([203.163.83.68]:7099 "EHLO
	tw-mx2.synaptics.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2JDFwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 01:52:47 -0400
From: Alexandra Chin <alexandra.chin@tw.synaptics.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: RE: [PATCH] Input: Add new driver into Input Subsystem for
 Synaptics DS4 touchscreen I2C devices
Thread-Topic: [PATCH] Input: Add new driver into Input Subsystem for
 Synaptics DS4 touchscreen I2C devices
Thread-Index: AQHNk/HhVA088HpSAk6VMBpKXya6/ZelpTiwgAFjI8CAAGvVgIABSqoA
Date: Thu, 4 Oct 2012 05:52:45 +0000
Message-ID: <CC51EC7B5B7F984AA566DC102237848896F593FA@hkdcw-mail1.synaptics-inc.local>
References: <CC51EC7B5B7F984AA566DC102237848896F590C0@hkdcw-mail1.synaptics-inc.local>
 <20121003180121.GA4198@polaris.bitmath.org>
In-Reply-To: <20121003180121.GA4198@polaris.bitmath.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-HK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.51.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Rydberg
Sent: Thursday, October 04, 2012 2:01 AM
> It seems this driver is already present in staging. Comments and
> formatting have been improved in the staging version, but that aside,
> the two versions look very similar.  Why don't you submit fixes to
> that driver instead?

> On a general note, both versions of the driver use MT-A. Please
> convert to MT-B, using the in-kernel tracking if necessary.


Hi Henrik,

Appreciate your suggestion!
We are going to update a patch of using MT-B, because Synaptics devices are 
capable of tracking identifiable contacts (type B).
Thanks for pointing out this.

You are right, there is already a synaptics_i2c_rmi4 driver in staging 
state (drivers/staging/ste_rmi4). 
Actually synaptics_ds4_i2c driver is developed based on synaptics_i2c_rmi4 
driver. The point is that we would want to make a clear definition that 
synaptics_ds4_i2c only targets to DS4 family, so that we can keep maintaining 
driver focusing on DS4 product line (not all Synaptics touchscreen devices are 
DS4 compatible).

We are open to discuss if it is appropriate to retained DS4 driver, and please 
let us know if you have any concerns.

Best Regards,
Alexandra Chin
