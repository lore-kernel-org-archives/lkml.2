Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0J0F2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:28:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:11279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0J0F2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,244,1286175600"; 
   d="scan'208";a="671269831"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH -v3 0/8] ACPI, APEI patches for 2.6.37
Date: Wed, 27 Oct 2010 13:28:24 +0800
Message-Id: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:

- Rework lock-less memory allocator and lock-less list.

v2:

- Some minor changes according to Andi's comments.

[PATCH -v3 1/8] ACPI, APEI, Add ERST record ID cache
[PATCH -v3 2/8] lib, Make gen_pool memory allocator lock-less
[PATCH -v3 3/8] lib, Add lock-less NULL terminated single list
[PATCH -v3 4/8] Hardware error device core
[PATCH -v3 5/8] Hardware error record persistent support
[PATCH -v3 6/8] ACPI, APEI, Use ERST for hardware error persisting before panic
[PATCH -v3 7/8] ACPI, APEI, Report GHES error record with hardware error device core
[PATCH -v3 8/8] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support
