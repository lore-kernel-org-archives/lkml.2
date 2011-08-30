Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab1H3G2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:28:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:54850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1H3G2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:28:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43510994"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [RFC 0/2] ACPI, APEI, EINJ, Fix RAM accessing
Date: Tue, 30 Aug 2011 14:28:27 +0800
Message-Id: <1314685709-7280-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some APEI firmware implementaiton will access injected address
specified in param1 to trigger the error when injecting memory error.
This may cause resource conflict with RAM and RAM accessing issue
in ACPI atomic IO support.  This patchset fixes this.

[RFC 1/2] ACPI, APEI, EINJ, Fix resource conflict on some machine
[RFC 2/2] ACPI, Add RAM mapping support to ACPI atomic IO support

Best Regards,
Huang Ying
