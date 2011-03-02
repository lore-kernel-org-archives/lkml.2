Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1CBRNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:13:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36642 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1CBRND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:13:03 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Williamson <michael.williamson@criticallink.com>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 2 Mar 2011 22:42:43 +0530
Subject: RE: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Thread-Topic: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
Thread-Index: AcvVrk3sdDgHpSlTSLiwuUzwIJ5gbwDTgBmQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C0082E3@dbde02.ent.ti.com>
References: <1297434088-27995-1-git-send-email-subhasish@mistralsolutions.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024BE49175@dbde02.ent.ti.com>
 <886E26C48DE446C3937D89ECF86030B2@subhasishg>
 <B85A65D85D7EB246BE421B3FB0FBB593024BE49711@dbde02.ent.ti.com>
 <25DBF349769A4CF7B883D6D7FF01AD70@subhasishg>
In-Reply-To: <25DBF349769A4CF7B883D6D7FF01AD70@subhasishg>
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

Hi Subhasish,

On Sat, Feb 26, 2011 at 17:42:39, Subhasish Ghosh wrote:
> Hi Sekhar,
> 
> I tried this using MMC and Kelvin's suggestions, but it never came back. 
> Here is a log:

Was this result with or without this patch applied?

> 
> root@arago:~# rtcwake -d /dev/rtc0 -s 20 -m mem
> wakeup from "mem" at Tue Apr 21 14:31:13 2009
> PM: Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.01 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> Suspending console(s) (use no_console_suspend to debug)
> 
> From the Kconfig I had enabled RTC_DRV_OMAP, CONFIG_PM, CONFIG_SUSPEND.

Nothing stands out from these logs. One thing to
verify is if the RTC Alarm interrupt is really
working by using the test program present in the
Documentation/ folder.

Anyway, the easiest way for you to move quickly is
to use ramdisk so you can bypass all driver specific
issues.

Thanks,
Sekhar

