Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2F0I7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 04:59:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6806 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2F0I7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 04:59:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,483,1336320000"; 
   d="scan'208";a="5273790"
Message-ID: <4FEACAA8.8010402@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 16:56:08 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v3 5/5] Documentation: Add ABI entry for vmcs sysfs interface
References: <4FEAC945.50700@cn.fujitsu.com>
In-Reply-To: <4FEAC945.50700@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:59:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/27 16:59:41,
	Serialize complete at 2012/06/27 16:59:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/ABI/testing/sysfs-devices-cpu-vmcs |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-cpu-vmcs

diff --git a/Documentation/ABI/testing/sysfs-devices-cpu-vmcs b/Documentation/ABI/testing/sysfs-devices-cpu-vmcs
new file mode 100644
index 0000000..0846b07
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-cpu-vmcs
@@ -0,0 +1,11 @@
+What:		/sys/devices/cpu/vmcs/
+Date:		June 2012
+KernelVersion:	3.5.0
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description:
+		A collection of vmcs fields' offsets for Intel cpu.
+
+		Individual offsets are contained in subfiles named by
+		the filed's encoding, e.g.:
+
+		/sys/devices/cpu/vmcs/0800
-- 
1.7.1

