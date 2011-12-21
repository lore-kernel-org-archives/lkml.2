Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1LUJ5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:57:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1LUJ5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:57:14 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Subject: RE: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Topic: [PATCH v2] davinci: DA850 EVM: OHCI platform code
Thread-Index: AQHMv7InDpObXctwwU2vJttYJMzT/5XmAl8w
Date: Wed, 21 Dec 2011 09:56:55 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6051CB9@DBDE01.ent.ti.com>
References: <1324452002-8388-1-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1324452002-8388-1-git-send-email-prakash.pm@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prakash,

On Wed, Dec 21, 2011 at 12:50:02, Manjunathappa, Prakash wrote:
> From: Ajay Kumar Gupta <ajay.gupta@ti.com>
> 
> On this board the OHCI port's power control and over-current signals from
> TPS2065 power switch are connected via GPIO2[4] and GPIO6[13] respectively,
> so we can implement the DA8xx OHCI glue layer's hooks for overriding the
> root hub port's power and over-current status bits.
> 
> We also have to properly set up the clocking mode in the CFGCHIP2 register,
> so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
> its output is used to clock the USB 1.1 (OHCI) PHY...
> 
> Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>

This is the third copy of OHCI platform setup code which is almost
the same except for the GPIO numbers. Can we attempt to consolidate
the GPIO case under drivers/usb/host/ohci-da8xx.c glue layer itself?
Of course, here should be a provision for non-GPIO based implementation
as well.

Sergei, any thoughts, comments?

Thanks,
Sekhar
