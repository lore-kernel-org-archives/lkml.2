Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab2EPH65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:58:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13668 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab2EPH6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:58:55 -0400
X-IronPort-AV: E=Sophos;i="4.75,602,1330876800"; 
   d="scan'208";a="4967728"
Message-ID: <4FB35DEF.2040008@cn.fujitsu.com>
Date: Wed, 16 May 2012 15:57:35 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: ebiederm@xmission.com, luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>,
        dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH v2 5/5] Documentation: Add ABI entry for sysfs file vmcsinfo
 and vmcsinfo_maxsize
References: <4FB35C48.30708@cn.fujitsu.com>
In-Reply-To: <4FB35C48.30708@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:57:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/16 15:57:43,
	Serialize complete at 2012/05/16 15:57:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We create two new sysfs files, vmcsinfo and vmcsinfo_maxsize. And
here we add an Documentation/ABI entry for them.

Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/ABI/testing/sysfs-kernel-vmcsinfo |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-vmcsinfo

diff --git a/Documentation/ABI/testing/sysfs-kernel-vmcsinfo b/Documentation/ABI/testing/sysfs-kernel-vmcsinfo
new file mode 100644
index 0000000..adbf866
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-vmcsinfo
@@ -0,0 +1,16 @@
+What:		/sys/kernel/vmcsinfo
+Date:		April 2012
+KernelVersion:	3.4.0
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description
+		Shows physical address of VMCSINFO. VMCSINFO contains
+		the VMCS revision identifier and encoded offsets of fields
+		in VMCS data on Intel processors equipped with the VT
+		extensions.
+
+What:		/sys/kernel/vmcsinfo_maxsize
+Date:		April 2012
+KernelVersion:	3.4.0
+Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
+Description
+		Shows max size of VMCSINFO.
-- 
1.7.1
