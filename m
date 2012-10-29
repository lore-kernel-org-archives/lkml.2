Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2J2InM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:43:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab2J2InH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:43:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,670,1344182400"; 
   d="scan'208";a="6091104"
From: Wen Congyang <wency@cn.fujitsu.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v3 0/2] fixes for mem= option
Date: Mon, 29 Oct 2012 16:48:42 +0800
Message-Id: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 16:42:23,
	Serialize complete at 2012/10/29 16:42:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation and implementation of 'mem=' option doesn't match, and the
option can't work for efi platform. This patchset updates the documentation
and make the option to work for efi platform.

Changes from v2 to v3:
    Patch1: X86-32 ===> X86

Changes from v1 to v2:
    Patch1: Just fix a typo error(ingoring -> ignoring).

Wen Congyang (2):
  update mem= option's spec according to its implementation
  x86: make 'mem=' option to work for efi platform

 Documentation/kernel-parameters.txt |  7 ++++---
 arch/x86/kernel/e820.c              | 29 +++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

-- 
1.8.0

