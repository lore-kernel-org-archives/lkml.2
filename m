Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0GAI3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:29:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:28759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0GAI3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,518,1272870000"; 
   d="scan'208";a="581752804"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
Subject: [BUGFIX 0/2] ACPI, APEI, Fix two bugs of APEI implementation
Date: Thu,  1 Jul 2010 16:29:01 +0800
Message-Id: <1277972943-1475-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two bugs of APEI implementaiton.

[BUGFIX 1/2] ACPI, APEI, Fix a typo of error path of apei_resources_request
[BUGFIX 2/2] ACPI, APEI, Rename CPER and GHES severity constants
