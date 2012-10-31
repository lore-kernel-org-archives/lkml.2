Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2JaJfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:35:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab2JaJeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:34:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/5] ACPI-based enumeration of devices that are not discoverable natively
Date: Wed, 31 Oct 2012 10:31:14 +0100
Message-ID: <1421417.rIOjExM5Pt@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patch series adds support for ACPI-based enumeration of devices
that aren't discoverable natively to the driver core and ACPI subsystem.  It
covers the generic part and the platform bus type support.

Since in this case the role of ACPI is analogous to the role of Device Trees,
the idea is to follow what Device Trees did previously.

[1/5] Move ACPI handle to struct device and add device IDs table to
      struct device_driver.

[2/5] Generic functions for matching ACPI device nodes.

[3/5] Export GSI registration/unregistration functions on x86 (needed by [5/5]).

[4/5] Export GSI registration/unregistration functions on ia64 (needed by [5/5]).

[5/5] ACPI-based device enumeration support for platform devices.

The patches are on top of the linux-next branch of the linux-pm.git tree
with the "ACPI / PM: ACPI power management callback routines for subsystems"
patch series applied (although that series is not strictly necessary for them
to work).  They have been tested by Mika.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
