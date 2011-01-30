Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1A3DP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 22:15:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:22257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1A3DP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 22:15:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,398,1291622400"; 
   d="scan'208";a="597720032"
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, ying.huang@intel.com,
        Tony Luck <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2 0/3] KVM, Replace is_hwpoison_address with __get_user_pages
Date: Sun, 30 Jan 2011 11:15:46 +0800
Message-Id: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:

- Export __get_user_pages, because we need other get_user_pages variants too.


[PATCH -v2 1/3] mm, export __get_user_pages
[PATCH -v2 2/3] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
[PATCH -v2 3/3] KVM, Replace is_hwpoison_address with __get_user_pages
