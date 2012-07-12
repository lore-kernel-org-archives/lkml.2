Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab2GLJ7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:59:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933357Ab2GLJ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:59:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,574,1336320000"; 
   d="scan'208";a="5382912"
Message-ID: <4FFE9FF0.1030501@cn.fujitsu.com>
Date: Thu, 12 Jul 2012 17:59:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v5 3/3] Documentation: Add ABI entry for vmcs sysfs interface
References: <4FFE9EDE.8080107@cn.fujitsu.com>
In-Reply-To: <4FFE9EDE.8080107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/12 17:59:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/12 17:59:32,
	Serialize complete at 2012/07/12 17:59:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5dab364..2d0bc7f 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -9,6 +9,26 @@ Description:
 
 		/sys/devices/system/cpu/cpu#/
 
+What:		/sys/devices/system/cpu/vmcs/
+Date:		June 2012
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description:
+		A collection of vmcs fields' offsets for Intel cpu.
+		Also including vmcs revision identifier.
+
+		Individual offsets are contained in subfiles named by
+		the filed's encoding, e.g.:
+
+		/sys/devices/system/cpu/vmcs/0800
+
+What:		/sys/devices/system/cpu/vmcs/id
+Date:		June 2012
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description:
+		Vmcs revision identifier in Intel cpu. The value enables
+		software to avoid using a VMCS region formatted for one
+		processor on a processor that uses a different format.
+
 What:		/sys/devices/system/cpu/kernel_max
 		/sys/devices/system/cpu/offline
 		/sys/devices/system/cpu/online
-- 
1.7.1
