Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab2GDKWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:22:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab2GDKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:22:11 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336320000"; 
   d="scan'208";a="5328243"
Message-ID: <4FF415A4.8040405@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 18:06:28 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v4 3/3] Documentation: Add ABI entry for vmcs sysfs interface
References: <4FF413D2.4030006@cn.fujitsu.com>
In-Reply-To: <4FF413D2.4030006@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:09:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:22:13,
	Serialize complete at 2012/07/04 18:22:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   21 ++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5dab364..6efbd6c 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,6 +9,27 @@ Description:
 
 		/sys/devices/system/cpu/cpu#/
 
+What:		/sys/devices/system/cpu/vmcs_id
+Date:		June 2012
+KernelVersion:	3.5.0
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description:
+		Vmcs revision identifier in Intel cpu. The value enables
+		software to avoid using a VMCS region formatted for one
+		processor on a processor that uses a different format.
+
+What:		/sys/devices/system/cpu/vmcs/
+Date:		June 2012
+KernelVersion:	3.5.0
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description:
+		A collection of vmcs fields' offsets for Intel cpu.
+
+		Individual offsets are contained in subfiles named by
+		the filed's encoding, e.g.:
+
+		/sys/devices/system/cpu/vmcs/0800
+
 What:		/sys/devices/system/cpu/kernel_max
 		/sys/devices/system/cpu/offline
 		/sys/devices/system/cpu/online
-- 
1.7.1
