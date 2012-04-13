Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2DMCVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 22:21:20 -0400
Received: from asix.com.tw ([113.196.140.82]:62266 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab2DMCVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 22:21:18 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <005301cd1871$87391a90$95ab4fb0$@com.tw> <20120412104936.65dd7683@pyramind.ukuu.org.uk>
In-Reply-To: <20120412104936.65dd7683@pyramind.ukuu.org.uk>
Subject: RE: Patch "USB: serial: mos7840: Supported MCS7810 device"
Date: Fri, 13 Apr 2012 10:20:52 +0800
Message-ID: <002701cd191c$1077d580$31678080$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0YkVKsNPiNGd0bQw+CMxOQVJBEsAAiFXUw
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your reply. As for your comment regarding the LED feature flag, the driver can provide a flag parameter for LED
feature so that users will be able to set this LED feature at loading the driver, and by default, this flag is set false (LED
feature is disabled). Could you let me know if this is what exactly matches your comment?

Regards,
Donald

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Thursday, April 12, 2012 5:50 PM
To: Donald
Cc: 'Greg KH'; 'open list:USB SUBSYSTEM'; 'open list'
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"

> +/* MCS7810 LED support */
> +#define MCS7810_HAS_LED

I would just enable this. Nobody is going to change it in their source code.


> +#ifdef MCS7810_HAS_LED
> +	/* Turn on MCS7810 LED */
> +	if (serial->num_ports == 1 && mos7840_port->mos7810_led_flag == 0) {

Same comment as before about leds and flags to indicate features.

All these if cases should be a feature flag of some kind

Alan


