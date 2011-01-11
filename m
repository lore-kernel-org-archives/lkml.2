Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1AKROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:14:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53463 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab1AKROt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:14:49 -0500
Date: Tue, 11 Jan 2011 09:14:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for January 11 (build errors/warnings summary)
Message-Id: <20110111091423.818b5a15.randy.dunlap@oracle.com>
In-Reply-To: <20110111143357.abe434a5.sfr@canb.auug.org.au>
References: <20110111143357.abe434a5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 14:33:57 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Reminder: do not add any v2.6.39 material to your linux-next included
> trees until after v2.6.38-rc1 is released.
> 
> Changes since 20110110:


drivers/thermal/thermal_sys.c build fails when CONFIG_NET is not enabled
Patch has been posted but not merged.


drivers/acpi/internal.h:94: warning: no return statement in function returning non-void


drivers/staging/ath6kl/os/linux/cfg80211.c:1378: warning: initialization from incompatible pointer type
drivers/staging/ath6kl/os/linux/cfg80211.c:1386: warning: initialization from incompatible pointer type
drivers/staging/ath6kl/os/linux/ioctl.c: In function 'ar6000_ioctl':
drivers/staging/ath6kl/os/linux/ioctl.c:4673: warning: the frame size of 1852 bytes is larger than 1024 bytes


drivers/staging/rt2860/common/mlme.c: In function 'BssTableSortByRssi':
drivers/staging/rt2860/common/mlme.c:4200: warning: the frame size of 1568 bytes is larger than 1024 bytes
drivers/staging/rt2860/common/cmm_aes.c: In function 'AES_GTK_KEY_WRAP':
drivers/staging/rt2860/common/cmm_aes.c:1248: warning: the frame size of 1084 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta/sync.c: In function 'PeerBeaconAtScanAction':
drivers/staging/rt2860/sta/sync.c:663: warning: the frame size of 1248 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta/sync.c: In function 'PeerBeacon':
drivers/staging/rt2860/sta/sync.c:1697: warning: the frame size of 1296 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta/sync.c: In function 'PeerBeaconAtJoinAction':
drivers/staging/rt2860/sta/sync.c:1033: warning: the frame size of 1256 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta/sync.c: In function 'MlmeStartReqAction':
drivers/staging/rt2860/sta/sync.c:545: warning: the frame size of 1060 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta/connect.c: In function 'CntlOidScanProc':
drivers/staging/rt2860/sta/connect.c:321: warning: the frame size of 1596 bytes is larger than 1024 bytes
drivers/staging/rt2860/rt_linux.c: In function 'send_monitor_packets':
drivers/staging/rt2860/rt_linux.c:903: warning: the frame size of 1080 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta_ioctl.c: In function 'rt_ioctl_iwaplist':
drivers/staging/rt2860/sta_ioctl.c:721: warning: the frame size of 1296 bytes is larger than 1024 bytes
drivers/staging/rt2860/sta_ioctl.c: In function 'rt_ioctl_siwmlme':
drivers/staging/rt2860/sta_ioctl.c:1615: warning: the frame size of 1584 bytes is larger than 1024 bytes


drivers/staging/vt6655/device_main.c: In function 'device_ioctl':
drivers/staging/vt6655/device_main.c:3579: warning: the frame size of 1296 bytes is larger than 1024 bytes
drivers/staging/vt6655/iwctl.c: In function 'iwctl_giwaplist':
drivers/staging/vt6655/iwctl.c:817: warning: the frame size of 1296 bytes is larger than 1024 bytes


drivers/media/radio/radio-aimslab.c:76: error: implicit declaration of function 'msleep'
(reported yesterday by Geert)


arch/x86/kernel/e820.c:734: error: implicit declaration of function 'suspend_nvs_register'
when CONFIG_ACPI is not enabled


fs/btrfs/ctree.h:1003: error: field 'super_kobj' has incomplete type
fs/btrfs/ctree.h:1074: error: field 'root_kobj' has incomplete type
needs <linux/kobject.h>
(already reported)



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
