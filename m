Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2GCGoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:44:25 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:58557 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2GCGoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:44:14 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap9MAKCU8k9V5qg+PGdsb2JhbABFihWsVhkBAQEBHhkNJ4IYAQEEATocIwULCANGFCUKGogZCbstFJBeYAOVNIVmjH8
X-IronPort-AV: E=Sophos;i="4.77,515,1336341600"; 
   d="scan'208";a="367410643"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 3 Jul 2012 08:44:07 +0200
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hid/Kconfig:7:error: recursive dependency detected!
Message-ID: <20120703064407.GA4854@polaris.bitmath.org>
References: <20120703040640.GA8236@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703040640.GA8236@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

> I got this error while doing randconfig test:
> 
>         drivers/hid/Kconfig:7:error: recursive dependency detected!
>         drivers/hid/Kconfig:7:  symbol HID is selected by USB_HID
>         drivers/hid/usbhid/Kconfig:4:   symbol USB_HID depends on HID

What kernel tree does this apply to? Reading through the code again
and testing your configuration, I cannot reproduce the
problem. Indeed, in my tree, USB_HID does not depend on HID.

For completeness, here are all the HID-related options in your attached file:

# CONFIG_BT_HIDP is not set
# HID support
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# USB HID support
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y
# USB HID Boot Protocol drivers
# Special HID drivers
CONFIG_HID_GENERIC=m
# USB HID support
# USB HID Boot Protocol drivers
CONFIG_USB_G_HID=m

Thanks,
Henrik
