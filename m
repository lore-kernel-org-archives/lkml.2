Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2CFLE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:04:29 -0500
Received: from mail.meprolight.com ([194.90.149.17]:54114 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756709Ab2CFLE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:04:28 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 6 Mar 2012 13:04:11 +0200
Subject: mx3-camera
Thread-Topic: mx3-camera
Thread-Index: AQHM+4jcFpj9YbXNIEiIYUjM9iw7uw==
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CBD5D8906@MEP-EXCH.meprolight.com>
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

Hi Guennadi,

I'm working on I.MX35 PDK platform with use 3.3.0-rc6 version of the Linux Kernel.  
Here is my Kernel boot message

"Linux video capture interface: v2.00
mx3-camera: probe of mx3-camera.0 failed with error -2"

This error comes from probe function of mx3 camera host driver.
Precisely in this part of the code:
 
mx3_cam->clk = clk_get(&pdev->dev, NULL);
if (IS_ERR(mx3_cam->clk)) {
	err = PTR_ERR(mx3_cam->clk);
	goto eclkget;
}

I will be glad for any help.

Regards,
Alex Gershgorin