Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767894Ab2KONvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:51:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767793Ab2KONvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:51:10 -0500
Date: Thu, 15 Nov 2012 14:51:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        JJ Ding <jj_ding@emc.com.tw>, Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification
 implementation
In-Reply-To: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1211151450140.15877@pobox.suse.cz>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Benjamin Tissoires wrote:

> Microsoft published the protocol specification of HID over i2c:
> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
> 
> This patch introduces an implementation of this protocol.
> 
> This implementation does not includes the ACPI part of the specification.
> This will come when ACPI 5.0 devices enumeration will be available.
> 
> Once the ACPI part is done, OEM will not have to declare HID over I2C
> devices in their platform specific driver.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>

Out of curiosity -- has this been tested on a real device (is there any 
such device available anyway?), or is that just the implementation of the 
defined protocol?

Thanks,

-- 
Jiri Kosina
SUSE Labs
