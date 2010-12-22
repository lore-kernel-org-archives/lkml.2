Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0LVCwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 21:52:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:52614 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0LVCwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 21:52:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,210,1291622400"; 
   d="scan'208";a="639093774"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, Dean Nelson <dnelson@redhat.com>
Subject: [RFC 0/3] KVM, HWPoison, unpoison address across rebooting
Date: Wed, 22 Dec 2010 10:51:54 +0800
Message-Id: <1292986317-2805-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpoison address across rebooting, to make it possible that a new
memory page can be allocated, so that guest system can successfully
reboot.

[RFC 1/3] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
[RFC 2/3] KVM, Replace is_hwpoison_address with get_user_pages_hwpoison
[RFC 3/3] KVM, HWPoison, unpoison address across rebooting
