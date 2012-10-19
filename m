Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab2JSKKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:10:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab2JSKKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:10:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6031093"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, bhelgaas@google.com,
        hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, muneda.takahiro@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RESEND PATCH v2 0/2] fixes for mem= option
Date: Fri, 19 Oct 2012 18:16:15 +0800
Message-Id: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:10:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 18:10:20,
	Serialize complete at 2012/10/19 18:10:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The documentation and implementation of 'mem=' option doesn't match, and the
option can't work for efi platform. This patchset updates the documentation
and make the option to work for efi platform.

I resend it again because HPA asked me to resend it some days after merge
window.

Changes from v1 to v2
    Patch1: Just fix a typo error(ingoring -> ignoring).

Wen Congyang (2):
  update mem= option's spec according to its implementation
  x86: make 'mem=' option to work for efi platform

 Documentation/kernel-parameters.txt |    7 ++++---
 arch/x86/kernel/e820.c              |   29 +++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 7 deletions(-)

