Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1CJJIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:08:53 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:58337 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab1CJJIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:08:51 -0500
Message-ID: <4D78951E.1000607@blueyonder.co.uk>
Date: Thu, 10 Mar 2011 09:08:46 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.38-rc8-git1 make headers_install failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/usr/src/linux-2.6.38-rc8-git1/usr/include/drm/drm_mode.h:85: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.38-rc8-git1/usr/include/drm/i915_drm.h:120: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.38-rc8-git1/usr/include/drm/mga_drm.h:260: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.38-rc8-git1/usr/include/drm/radeon_drm.h:758: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
/usr/src/linux-2.6.38-rc8-git1/usr/include/drm/via_drm.h:117: found 
__[us]{8,16,32,64} type without #include <linux/types.h>
   CHECK   include/linux/caif (2 files)
   CHECK   include/linux/dvb (8 files)
   CHECK   include/linux/can (4 files)
   CHECK   include/rdma (1 files)
   CHECK   include/scsi/fc (4 files)
   CHECK   include/scsi (3 files)
   CHECK   include/linux/hdlc (1 files)
   CHECK   include/linux/isdn (1 files)
/usr/src/linux-2.6.38-rc8-git1/usr/include/scsi/scsi_netlink.h:108: 
found __[us]{8,16,32,64} type without #include <linux/types.h>
   CHECK   include/sound (8 files)
   CHECK   include/linux/netfilter (64 files)
   CHECK   include/video (3 files)
   CHECK   include/linux/netfilter_arp (2 files)
   CHECK   include/linux/netfilter_ipv4 (14 files)
   CHECK   include/linux/netfilter_bridge (18 files)
   CHECK   include/linux/netfilter_ipv6 (11 files)
   CHECK   include/linux/nfsd (6 files)
   CHECK   include/linux/raid (2 files)
   CHECK   include/xen (2 files)
   CHECK   include/linux/spi (1 files)
   CHECK   include/linux/sunrpc (1 files)
   CHECK   include (0 files)
   CHECK   include/linux/tc_ematch (4 files)
   CHECK   include/linux/tc_act (7 files)
   CHECK   include/linux/usb (8 files)
   CHECK   include/linux/wimax (1 files)
   CHECK   include/linux (360 files)
/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/kernel.h:58: userspace 
cannot reference function or variable defined in the kernel
/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/quota.h:175: userspace 
cannot reference function or variable defined in the kernel
/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/sdla.h:116: userspace 
cannot reference function or variable defined in the kernel
/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/soundcard.h:1054: 
userspace cannot reference function or variable defined in the kernel
/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/sysctl.h:28: included 
file 'linux/rcupdate.h' is not exported
make[3]: *** [/usr/src/linux-2.6.38-rc8-git1/usr/include/linux/.check] 
Error 123
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

